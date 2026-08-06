#!/usr/bin/env bash

set -Eeuo pipefail

TARGET_VERSION="${TARGET_VERSION:-}"

fail() {
  printf '[FAIL] %s\n' "$1" >&2
  exit 1
}

command -v kubectl >/dev/null 2>&1 ||
  fail "kubectl is required."

command -v k3s >/dev/null 2>&1 ||
  fail "k3s is required."

[[ -n "${TARGET_VERSION}" ]] ||
  fail "TARGET_VERSION is required."

kubectl cluster-info >/dev/null

kubectl wait \
  node \
  --all \
  --for=condition=Ready \
  --timeout=300s

not_ready_pods="$(
  kubectl get pods \
    --all-namespaces \
    --field-selector=status.phase!=Running,status.phase!=Succeeded \
    --no-headers 2>/dev/null |
    wc -l
)"

(( not_ready_pods == 0 )) ||
  fail "Cluster contains unhealthy pods."

current_version="$(k3s --version | awk 'NR==1 {print $3}')"

[[ "${current_version}" != "${TARGET_VERSION}" ]] ||
  fail "Cluster is already running ${TARGET_VERSION}."

printf '[INFO] Upgrade preflight passed: %s -> %s\n' \
  "${current_version}" \
  "${TARGET_VERSION}"
