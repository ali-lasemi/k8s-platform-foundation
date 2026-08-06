#!/usr/bin/env bash

set -Eeuo pipefail

NODE_NAME="${1:-}"
TIMEOUT="${NODE_VALIDATION_TIMEOUT:-300s}"

fail() {
  printf '[FAIL] %s\n' "$1" >&2
  exit 1
}

command -v kubectl >/dev/null 2>&1 \
  || fail "kubectl is required."

[[ -n "${NODE_NAME}" ]] \
  || fail "Usage: $0 NODE_NAME"

kubectl wait \
  node/"${NODE_NAME}" \
  --for=condition=Ready \
  --timeout="${TIMEOUT}"

unschedulable="$(
  kubectl get node "${NODE_NAME}" \
    -o jsonpath='{.spec.unschedulable}'
)"

[[ "${unschedulable}" != "true" ]] \
  || fail "Node ${NODE_NAME} is still cordoned."

pressure_conditions="$(
  kubectl get node "${NODE_NAME}" \
    -o jsonpath='{range .status.conditions[?(@.status=="True")]}{.type}{"\n"}{end}' \
    | grep -E 'DiskPressure|MemoryPressure|PIDPressure|NetworkUnavailable' \
    || true
)"

[[ -z "${pressure_conditions}" ]] \
  || fail "Node pressure detected: ${pressure_conditions}"

printf '[INFO] Node %s validation passed.\n' "${NODE_NAME}"
