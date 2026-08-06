#!/usr/bin/env bash

set -Eeuo pipefail

TIMEOUT="${PLATFORM_HEALTH_TIMEOUT:-300s}"

log() {
  printf '[CHECK] %s\n' "$1"
}

fail() {
  printf '[FAIL] %s\n' "$1" >&2
  exit 1
}

require_command() {
  command -v "$1" >/dev/null 2>&1 \
    || fail "Required command not found: $1"
}

wait_for_deployment() {
  local namespace="$1"
  local deployment="$2"

  log "Waiting for ${namespace}/${deployment}"

  kubectl rollout status \
    deployment/"${deployment}" \
    --namespace "${namespace}" \
    --timeout "${TIMEOUT}"
}

main() {
  require_command kubectl

  wait_for_deployment cert-manager cert-manager
  wait_for_deployment cert-manager cert-manager-webhook
  wait_for_deployment cert-manager cert-manager-cainjector
  wait_for_deployment traefik-system traefik
  wait_for_deployment metallb-system metallb-controller

  log "Checking MetalLB speaker DaemonSet"

  kubectl rollout status \
    daemonset/metallb-speaker \
    --namespace metallb-system \
    --timeout "${TIMEOUT}"

  log "Checking Helm releases"

  kubectl get helmreleases \
    --all-namespaces

  log "Platform services are healthy."
}

main "$@"
