#!/usr/bin/env bash

set -Eeuo pipefail

SNAPSHOT_PATH="${1:-}"

fail() {
  printf '[ERROR] %s\n' "$1" >&2
  exit 1
}

[[ -n "${SNAPSHOT_PATH}" ]] \
  || fail "Usage: $0 /path/to/snapshot"

[[ -f "${SNAPSHOT_PATH}" ]] \
  || fail "Snapshot not found: ${SNAPSHOT_PATH}"

[[ -f "${SNAPSHOT_PATH}.sha256" ]] \
  || fail "Checksum not found: ${SNAPSHOT_PATH}.sha256"

sha256sum --check "${SNAPSHOT_PATH}.sha256"

printf '[INFO] Snapshot checksum validation passed.\n'
