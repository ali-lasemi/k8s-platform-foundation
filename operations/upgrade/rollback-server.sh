#!/usr/bin/env bash

set -Eeuo pipefail

ROLLBACK_VERSION="${ROLLBACK_VERSION:-}"
CONFIRM_ROLLBACK="${CONFIRM_ROLLBACK:-false}"

fail() {
  printf '[ERROR] %s\n' "$1" >&2
  exit 1
}

[[ "${EUID}" -eq 0 ]] ||
  fail "Run this script as root."

[[ -n "${ROLLBACK_VERSION}" ]] ||
  fail "ROLLBACK_VERSION is required."

[[ "${CONFIRM_ROLLBACK}" == "true" ]] ||
  fail "Set CONFIRM_ROLLBACK=true to continue."

curl -sfL https://get.k3s.io |
  INSTALL_K3S_VERSION="${ROLLBACK_VERSION}" \
  INSTALL_K3S_EXEC="server --disable traefik --write-kubeconfig-mode 640" \
  sh -

systemctl restart k3s
systemctl is-active --quiet k3s
