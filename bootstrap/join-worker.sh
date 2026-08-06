#!/usr/bin/env bash

set -Eeuo pipefail

: "${K3S_URL:?K3S_URL is required}"
: "${K3S_TOKEN:?K3S_TOKEN is required}"

K3S_VERSION="${K3S_VERSION:-v1.36.1+k3s1}"

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

  if systemctl is-active --quiet k3s-agent 2>/dev/null; then
    log "k3s agent is already running. No changes applied."
    exit 0
  fi

  log "Joining worker to ${K3S_URL}"

  curl -sfL https://get.k3s.io | \
    INSTALL_K3S_VERSION="${K3S_VERSION}" \
    K3S_URL="${K3S_URL}" \
    K3S_TOKEN="${K3S_TOKEN}" \
    sh -

  systemctl is-active --quiet k3s-agent || fail "k3s agent failed to start."

  log "Worker joined successfully."
}

main "$@"
