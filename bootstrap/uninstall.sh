#!/usr/bin/env bash

set -Eeuo pipefail

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

  if [[ -x /usr/local/bin/k3s-uninstall.sh ]]; then
    log "Removing k3s server installation."
    /usr/local/bin/k3s-uninstall.sh
  fi

  if [[ -x /usr/local/bin/k3s-agent-uninstall.sh ]]; then
    log "Removing k3s agent installation."
    /usr/local/bin/k3s-agent-uninstall.sh
  fi

  log "Uninstall completed."
}

main "$@"
