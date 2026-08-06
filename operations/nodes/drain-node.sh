#!/usr/bin/env bash

set -Eeuo pipefail

NODE_NAME="${1:-}"
TIMEOUT="${DRAIN_TIMEOUT:-10m}"
GRACE_PERIOD="${DRAIN_GRACE_PERIOD:-60}"
DELETE_EMPTYDIR_DATA="${DELETE_EMPTYDIR_DATA:-false}"

log() {
  printf '[INFO] %s\n' "$1"
}

fail() {
  printf '[ERROR] %s\n' "$1" >&2
  exit 1
}

require_command() {
  command -v "$1" >/dev/null 2>&1 \
    || fail "Required command not found: $1"
}

main() {
  require_command kubectl

  [[ -n "${NODE_NAME}" ]] \
    || fail "Usage: $0 NODE_NAME"

  kubectl get node "${NODE_NAME}" >/dev/null 2>&1 \
    || fail "Node not found: ${NODE_NAME}"

  log "Cordoning node ${NODE_NAME}"
  kubectl cordon "${NODE_NAME}"

  drain_args=(
    "${NODE_NAME}"
    "--ignore-daemonsets"
    "--grace-period=${GRACE_PERIOD}"
    "--timeout=${TIMEOUT}"
  )

  if [[ "${DELETE_EMPTYDIR_DATA}" == "true" ]]; then
    drain_args+=("--delete-emptydir-data")
  fi

  log "Draining node ${NODE_NAME}"
  kubectl drain "${drain_args[@]}"

  log "Node ${NODE_NAME} drained successfully."
}

main "$@"
