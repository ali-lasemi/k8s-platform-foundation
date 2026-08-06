#!/usr/bin/env bash

set -Eeuo pipefail

FLUX_VERSION="${FLUX_VERSION:-2.9.3}"
REPOSITORY_OWNER="${REPOSITORY_OWNER:-ali-lasemi}"
REPOSITORY_NAME="${REPOSITORY_NAME:-k8s-platform-foundation}"
REPOSITORY_BRANCH="${REPOSITORY_BRANCH:-main}"

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
  require_command curl
  require_command tar

  if ! command -v flux >/dev/null 2>&1; then
    log "Installing Flux CLI ${FLUX_VERSION}"

    curl -sSfL \
      "https://github.com/fluxcd/flux2/releases/download/v${FLUX_VERSION}/flux_${FLUX_VERSION}_linux_amd64.tar.gz" \
      | tar -xz -C /usr/local/bin flux

    chmod 0755 /usr/local/bin/flux
  fi

  log "Running Flux prerequisites check"
  flux check --pre

  log "Installing Flux controllers"
  flux install \
    --namespace=flux-system \
    --components=source-controller,kustomize-controller,helm-controller,notification-controller \
    --network-policy=true

  log "Applying repository synchronization configuration"
  kubectl apply -k gitops/flux-system

  log "Flux bootstrap completed for ${REPOSITORY_OWNER}/${REPOSITORY_NAME}:${REPOSITORY_BRANCH}"
}

main "$@"
