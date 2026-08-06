#!/usr/bin/env bash

set -Eeuo pipefail

SNAPSHOT_NAME="${SNAPSHOT_NAME:-manual}"
SNAPSHOT_RETENTION="${SNAPSHOT_RETENTION:-10}"
SNAPSHOT_DIR="${SNAPSHOT_DIR:-/var/lib/rancher/k3s/server/db/snapshots}"

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

require_command() {
  command -v "$1" >/dev/null 2>&1 \
    || fail "Required command not found: $1"
}

main() {
  require_root
  require_command k3s
  require_command sha256sum

  log "Creating compressed etcd snapshot"

  k3s etcd-snapshot save \
    --name "${SNAPSHOT_NAME}" \
    --etcd-snapshot-compress \
    --etcd-snapshot-dir "${SNAPSHOT_DIR}"

  latest_snapshot="$(
    find "${SNAPSHOT_DIR}" \
      -maxdepth 1 \
      -type f \
      -name "${SNAPSHOT_NAME}-*" \
      -printf '%T@ %p\n' \
      | sort -nr \
      | head -n 1 \
      | cut -d' ' -f2-
  )"

  [[ -n "${latest_snapshot}" ]] \
    || fail "Snapshot file was not found after creation."

  sha256sum "${latest_snapshot}" >"${latest_snapshot}.sha256"

  log "Pruning old snapshots"

  k3s etcd-snapshot prune \
    --name "${SNAPSHOT_NAME}" \
    --snapshot-retention "${SNAPSHOT_RETENTION}" \
    --etcd-snapshot-dir "${SNAPSHOT_DIR}"

  log "Snapshot created: ${latest_snapshot}"
  log "Checksum created: ${latest_snapshot}.sha256"
}

main "$@"
