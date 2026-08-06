#!/usr/bin/env bash

set -Eeuo pipefail

CONFIRM_ROTATION="${CONFIRM_ROTATION:-false}"
ROTATION_SCOPE="${ROTATION_SCOPE:-all}"

log() {
  printf '[INFO] %s\n' "$1"
}

fail() {
  printf '[ERROR] %s\n' "$1" >&2
  exit 1
}

[[ "${EUID}" -eq 0 ]] \
  || fail "Run this script as root."

[[ "${CONFIRM_ROTATION}" == "true" ]] \
  || fail "Set CONFIRM_ROTATION=true to continue."

command -v k3s >/dev/null 2>&1 \
  || fail "k3s is required."

command -v systemctl >/dev/null 2>&1 \
  || fail "systemctl is required."

log "Stopping k3s"
systemctl stop k3s

case "${ROTATION_SCOPE}" in
  all)
    log "Rotating all k3s certificates"
    k3s certificate rotate
    ;;
  server)
    log "Rotating server certificates"
    k3s certificate rotate --service api-server
    ;;
  *)
    fail "Unsupported ROTATION_SCOPE: ${ROTATION_SCOPE}"
    ;;
esac

log "Starting k3s"
systemctl start k3s

systemctl is-active --quiet k3s \
  || fail "k3s failed after certificate rotation."

log "Certificate rotation completed."
