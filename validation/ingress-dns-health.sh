#!/usr/bin/env bash

set -Eeuo pipefail

TIMEOUT="${INGRESS_DNS_TIMEOUT:-600s}"
DEMO_HOST="${DEMO_HOST:-demo.platform.example.com}"

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

main() {
  require_command kubectl

  log "Checking Traefik"
  kubectl rollout status \
    deployment/traefik \
    --namespace traefik-system \
    --timeout "${TIMEOUT}"

  log "Checking cert-manager"
  kubectl rollout status \
    deployment/cert-manager \
    --namespace cert-manager \
    --timeout "${TIMEOUT}"

  kubectl rollout status \
    deployment/cert-manager-webhook \
    --namespace cert-manager \
    --timeout "${TIMEOUT}"

  log "Checking ExternalDNS"
  kubectl rollout status \
    deployment/external-dns \
    --namespace external-dns \
    --timeout "${TIMEOUT}"

  log "Checking ingress demo"
  kubectl rollout status \
    deployment/ingress-demo \
    --namespace ingress-demo \
    --timeout "${TIMEOUT}"

  log "Checking ClusterIssuers"
  kubectl get clusterissuer letsencrypt-staging >/dev/null
  kubectl get clusterissuer letsencrypt-production >/dev/null

  log "Checking ingress TLS configuration"
  tls_secret="$(
    kubectl get ingress ingress-demo \
      --namespace ingress-demo \
      -o jsonpath='{.spec.tls[0].secretName}'
  )"

  [[ "${tls_secret}" == "ingress-demo-tls" ]] \
    || fail "Unexpected TLS Secret: ${tls_secret}"

  configured_host="$(
    kubectl get ingress ingress-demo \
      --namespace ingress-demo \
      -o jsonpath='{.spec.rules[0].host}'
  )"

  [[ "${configured_host}" == "${DEMO_HOST}" ]] \
    || fail "Unexpected ingress hostname: ${configured_host}"

  log "Ingress and DNS platform validation passed."
}

main "$@"
