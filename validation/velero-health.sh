#!/usr/bin/env bash

set -Eeuo pipefail

TIMEOUT="${VELERO_TIMEOUT:-300s}"

fail() {
  printf '[FAIL] %s\n' "$1" >&2
  exit 1
}

command -v kubectl >/dev/null 2>&1 ||
  fail "kubectl is required."

kubectl rollout status \
  deployment/velero \
  --namespace velero \
  --timeout "${TIMEOUT}"

kubectl get backupstoragelocation \
  --namespace velero \
  >/dev/null

available="$(
  kubectl get backupstoragelocation default \
    --namespace velero \
    -o jsonpath='{.status.phase}'
)"

[[ "${available}" == "Available" ]] ||
  fail "Velero backup storage location is not available."

kubectl get schedules \
  --namespace velero \
  >/dev/null

printf '[INFO] Velero validation passed.\n'
