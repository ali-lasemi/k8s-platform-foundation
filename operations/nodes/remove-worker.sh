#!/usr/bin/env bash

set -Eeuo pipefail

NODE_NAME="${1:-}"
CONFIRM_REMOVE="${CONFIRM_REMOVE:-false}"

log() {
  printf '[INFO] %s\n' "$1"
}

fail() {
  printf '[ERROR] %s\n' "$1" >&2
  exit 1
}

main() {
  command -v kubectl >/dev/null 2>&1 ||
    fail "kubectl is required."

  [[ -n "${NODE_NAME}" ]] ||
    fail "Usage: $0 NODE_NAME"

  [[ "${CONFIRM_REMOVE}" == "true" ]] ||
    fail "Set CONFIRM_REMOVE=true to remove the node."

  kubectl get node "${NODE_NAME}" >/dev/null 2>&1 ||
    fail "Node not found: ${NODE_NAME}"

  log "Draining node ${NODE_NAME}"

  kubectl drain "${NODE_NAME}" \
    --ignore-daemonsets \
    --delete-emptydir-data \
    --grace-period=60 \
    --timeout=10m

  log "Deleting node ${NODE_NAME}"
  kubectl delete node "${NODE_NAME}"

  log "Worker node removed from the cluster."
}

main "$@"
