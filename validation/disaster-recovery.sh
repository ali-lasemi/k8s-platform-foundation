#!/usr/bin/env bash

set -Eeuo pipefail

fail() {
  printf '[FAIL] %s\n' "$1" >&2
  exit 1
}

required_scripts=(
  backup/etcd/snapshot.sh
  backup/etcd/verify.sh
  backup/etcd/restore.sh
  backup/etcd/install-systemd.sh
  backup/velero/backup-check.sh
)

for script in "${required_scripts[@]}"; do
  [[ -x "${script}" ]] ||
    fail "Script is not executable: ${script}"

  bash -n "${script}"
done

grep -q 'CONFIRM_RESTORE' backup/etcd/restore.sh ||
  fail "Restore confirmation guard is missing."

grep -q 'sha256sum --check' backup/etcd/verify.sh ||
  fail "Snapshot checksum verification is missing."

grep -q 'Persistent=true' backup/etcd/install-systemd.sh ||
  fail "Persistent systemd timer configuration is missing."

printf '[INFO] Disaster-recovery static validation passed.\n'
