#!/usr/bin/env bash

set -Eeuo pipefail

SOURCE_KUBECONFIG="${SOURCE_KUBECONFIG:-/etc/rancher/k3s/k3s.yaml}"
OUTPUT_KUBECONFIG="${OUTPUT_KUBECONFIG:-${HOME}/.kube/config}"
SERVER_ADDRESS="${SERVER_ADDRESS:-}"

log() {
  printf '[INFO] %s\n' "$1"
}

fail() {
  printf '[ERROR] %s\n' "$1" >&2
  exit 1
}

main() {
  [[ -r "${SOURCE_KUBECONFIG}" ]] \
    || fail "Cannot read kubeconfig: ${SOURCE_KUBECONFIG}"

  install -d -m 700 "$(dirname "${OUTPUT_KUBECONFIG}")"
  install -m 600 "${SOURCE_KUBECONFIG}" "${OUTPUT_KUBECONFIG}"

  if [[ -n "${SERVER_ADDRESS}" ]]; then
    sed -i \
      "s#https://127.0.0.1:6443#https://${SERVER_ADDRESS}:6443#g" \
      "${OUTPUT_KUBECONFIG}"
  fi

  log "Kubeconfig exported to ${OUTPUT_KUBECONFIG}"
}

main "$@"
