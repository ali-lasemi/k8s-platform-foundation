#!/usr/bin/env bash

set -Eeuo pipefail

K3S_VERSION="${K3S_VERSION:-v1.36.1+k3s1}"
INSTALL_K3S_EXEC="${INSTALL_K3S_EXEC:---disable traefik --write-kubeconfig-mode 640}"

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
  command -v "$1" >/dev/null 2>&1 || fail "Required command not found: $1"
}

main() {
  require_root
  require_command curl

  if systemctl is-active --quiet k3s 2>/dev/null; then
    log "k3s is already running. No changes applied."
    exit 0
  fi

  log "Installing k3s ${K3S_VERSION}"

  curl -sfL https://get.k3s.io | \
    INSTALL_K3S_VERSION="${K3S_VERSION}" \
    INSTALL_K3S_EXEC="${INSTALL_K3S_EXEC}" \
    sh -

  systemctl is-active --quiet k3s || fail "k3s service failed to start."

  log "k3s installation completed successfully."
}

main "$@"
