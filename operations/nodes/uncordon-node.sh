#!/usr/bin/env bash

set -Eeuo pipefail

NODE_NAME="${1:-}"

fail() {
  printf '[ERROR] %s\n' "$1" >&2
  exit 1
}

command -v kubectl >/dev/null 2>&1 \
  || fail "kubectl is required."

[[ -n "${NODE_NAME}" ]] \
  || fail "Usage: $0 NODE_NAME"

kubectl get node "${NODE_NAME}" >/dev/null 2>&1 \
  || fail "Node not found: ${NODE_NAME}"

kubectl uncordon "${NODE_NAME}"

kubectl wait \
  node/"${NODE_NAME}" \
  --for=condition=Ready \
  --timeout=300s

printf '[INFO] Node %s is schedulable and ready.\n' "${NODE_NAME}"
