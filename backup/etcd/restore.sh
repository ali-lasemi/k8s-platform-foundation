#!/usr/bin/env bash

set -Eeuo pipefail

SNAPSHOT_PATH="${1:-}"
CONFIRM_RESTORE="${CONFIRM_RESTORE:-false}"

log() {
  printf '[INFO] %s\n' "$1"
}

fail() {
  printf '[ERROR] %s\n' "$1" >&2
  exit 1
}

require_root() {
  [[ "${EUID}" -eq 0 ]] || fail "Run this script as root."
}

main() {
  require_root

  [[ -n "${SNAPSHOT_PATH}" ]] ||
    fail "Usage: $0 /path/to/snapshot"

  [[ -f "${SNAPSHOT_PATH}" ]] ||
    fail "Snapshot not found: ${SNAPSHOT_PATH}"

  [[ "${CONFIRM_RESTORE}" == "true" ]] ||
    fail "Set CONFIRM_RESTORE=true to continue."

  if [[ -f "${SNAPSHOT_PATH}.sha256" ]]; then
    sha256sum --check "${SNAPSHOT_PATH}.sha256"
  fi

  log "Stopping k3s"
  systemctl stop k3s

  log "Restoring etcd snapshot"

  k3s server \
    --cluster-reset \
    --cluster-reset-restore-path="${SNAPSHOT_PATH}"

  log "Starting k3s"
  systemctl start k3s

  systemctl is-active --quiet k3s ||
    fail "k3s failed to start after restore."

  log "Restore completed successfully."
}

main "$@"
