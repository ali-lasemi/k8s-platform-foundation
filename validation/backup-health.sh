#!/usr/bin/env bash

set -Eeuo pipefail

SNAPSHOT_DIR="${SNAPSHOT_DIR:-/var/lib/rancher/k3s/server/db/snapshots}"
MAX_AGE_HOURS="${MAX_AGE_HOURS:-12}"

fail() {
  printf '[FAIL] %s\n' "$1" >&2
  exit 1
}

latest_snapshot="$(
  find "${SNAPSHOT_DIR}" \
    -maxdepth 1 \
    -type f \
    ! -name '*.sha256' \
    -printf '%T@ %p\n' |
    sort -nr |
    head -n 1 |
    cut -d' ' -f2-
)"

[[ -n "${latest_snapshot}" ]] ||
  fail "No etcd snapshots found."

[[ -f "${latest_snapshot}.sha256" ]] ||
  fail "Checksum missing for ${latest_snapshot}"

sha256sum --check "${latest_snapshot}.sha256"

snapshot_epoch="$(stat -c %Y "${latest_snapshot}")"
current_epoch="$(date +%s)"
age_hours="$(( (current_epoch - snapshot_epoch) / 3600 ))"

(( age_hours <= MAX_AGE_HOURS )) ||
  fail "Latest snapshot is ${age_hours} hours old."

printf '[INFO] Backup validation passed.\n'
