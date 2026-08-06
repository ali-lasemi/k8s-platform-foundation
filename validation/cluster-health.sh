#!/usr/bin/env bash

set -Eeuo pipefail

log() {
  printf '[CHECK] %s\n' "$1"
}

fail() {
  printf '[FAIL] %s\n' "$1" >&2
  exit 1
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || fail "Required command not found: $1"
}

main() {
  require_command kubectl

  log "Checking Kubernetes API"
  kubectl cluster-info >/dev/null

  log "Checking node readiness"
  kubectl wait \
    --for=condition=Ready \
    nodes \
    --all \
    --timeout=120s

  log "Checking system pods"
  kubectl wait \
    --for=condition=Ready \
    pods \
    --all \
    --all-namespaces \
    --timeout=180s

  log "Checking CoreDNS"
  kubectl get deployment coredns \
    --namespace kube-system \
    >/dev/null

  log "Checking storage classes"
  kubectl get storageclass >/dev/null

  log "Cluster health validation passed."
}

main "$@"
