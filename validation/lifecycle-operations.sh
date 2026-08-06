#!/usr/bin/env bash

set -Eeuo pipefail

fail() {
  printf '[FAIL] %s\n' "$1" >&2
  exit 1
}

scripts=(
  operations/nodes/drain-node.sh
  operations/nodes/uncordon-node.sh
  operations/nodes/remove-worker.sh
  operations/nodes/validate-node.sh
  operations/upgrade/preflight.sh
  operations/upgrade/upgrade-server.sh
  operations/upgrade/upgrade-agent.sh
  operations/upgrade/rollback-server.sh
  operations/certificates/rotate-k3s-certificates.sh
  operations/certificates/check-expiry.sh
)

for script in "${scripts[@]}"; do
  [[ -f "${script}" ]] \
    || fail "Missing script: ${script}"

  bash -n "${script}"
done

grep -q 'CONFIRM_UPGRADE' operations/upgrade/upgrade-server.sh \
  || fail "Upgrade confirmation guard is missing."

grep -q 'CONFIRM_ROLLBACK' operations/upgrade/rollback-server.sh \
  || fail "Rollback confirmation guard is missing."

grep -q 'CONFIRM_REMOVE' operations/nodes/remove-worker.sh \
  || fail "Node removal confirmation guard is missing."

grep -q 'CONFIRM_ROTATION' operations/certificates/rotate-k3s-certificates.sh \
  || fail "Certificate rotation confirmation guard is missing."

printf '[INFO] Lifecycle operation validation passed.\n'
