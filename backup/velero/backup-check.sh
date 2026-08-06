#!/usr/bin/env bash

set -Eeuo pipefail

BACKUP_NAME="${BACKUP_NAME:-platform-validation-$(date +%Y%m%d%H%M%S)}"
TIMEOUT="${BACKUP_TIMEOUT:-900s}"

fail() {
  printf '[FAIL] %s\n' "$1" >&2
  exit 1
}

command -v kubectl >/dev/null 2>&1 \
  || fail "kubectl is required."

kubectl create backup "${BACKUP_NAME}" \
  --namespace velero \
  --from-schedule daily-platform-backup

end_time="$((SECONDS + 900))"

while ((SECONDS < end_time)); do
  phase="$(
    kubectl get backup "${BACKUP_NAME}" \
      --namespace velero \
      -o jsonpath='{.status.phase}' 2>/dev/null || true
  )"

  case "${phase}" in
    Completed)
      printf '[INFO] Backup %s completed successfully.\n' "${BACKUP_NAME}"
      exit 0
      ;;
    Failed | PartiallyFailed)
      kubectl describe backup "${BACKUP_NAME}" --namespace velero
      fail "Backup ${BACKUP_NAME} failed with phase ${phase}."
      ;;
  esac

  sleep 10
done

fail "Backup ${BACKUP_NAME} did not complete within ${TIMEOUT}."
