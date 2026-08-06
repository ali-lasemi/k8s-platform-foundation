#!/usr/bin/env bash

set -Eeuo pipefail

TARGET_VERSION="${TARGET_VERSION:-}"
CONFIRM_UPGRADE="${CONFIRM_UPGRADE:-false}"

log() {
  printf '[INFO] %s\n' "$1"
}

fail() {
  printf '[ERROR] %s\n' "$1" >&2
  exit 1
}

[[ "${EUID}" -eq 0 ]] ||
  fail "Run this script as root."

[[ -n "${TARGET_VERSION}" ]] ||
  fail "TARGET_VERSION is required."

[[ "${CONFIRM_UPGRADE}" == "true" ]] ||
  fail "Set CONFIRM_UPGRADE=true to continue."

command -v curl >/dev/null 2>&1 ||
  fail "curl is required."

log "Upgrading k3s server to ${TARGET_VERSION}"

curl -sfL https://get.k3s.io |
  INSTALL_K3S_VERSION="${TARGET_VERSION}" \
  INSTALL_K3S_EXEC="server --disable traefik --write-kubeconfig-mode 640" \
  sh -

systemctl restart k3s
systemctl is-active --quiet k3s ||
  fail "k3s failed after upgrade."

log "k3s server upgrade completed."
