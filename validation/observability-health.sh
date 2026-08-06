#!/usr/bin/env bash

set -Eeuo pipefail

TIMEOUT="${OBSERVABILITY_TIMEOUT:-600s}"

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

wait_deployment() {
  local name="$1"

  kubectl rollout status \
    deployment/"${name}" \
    --namespace observability \
    --timeout "${TIMEOUT}"
}

main() {
  require_command kubectl

  log "Checking Prometheus Operator"
  wait_deployment kube-prometheus-stack-operator

  log "Checking Grafana"
  wait_deployment kube-prometheus-stack-grafana

  log "Checking Loki gateway"
  wait_deployment loki-gateway

  log "Checking Alloy DaemonSet"
  kubectl rollout status \
    daemonset/alloy \
    --namespace observability \
    --timeout "${TIMEOUT}"

  log "Checking Prometheus instances"
  kubectl wait \
    pod \
    --namespace observability \
    --selector=app.kubernetes.io/name=prometheus \
    --for=condition=Ready \
    --timeout "${TIMEOUT}"

  log "Checking Alertmanager instances"
  kubectl wait \
    pod \
    --namespace observability \
    --selector=app.kubernetes.io/name=alertmanager \
    --for=condition=Ready \
    --timeout "${TIMEOUT}"

  log "Checking Prometheus rules"
  kubectl get prometheusrules \
    --namespace observability \
    >/dev/null

  log "Checking ServiceMonitors"
  kubectl get servicemonitors \
    --all-namespaces \
    >/dev/null

  log "Observability platform is healthy."
}

main "$@"
