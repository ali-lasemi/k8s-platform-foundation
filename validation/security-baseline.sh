#!/usr/bin/env bash

set -Eeuo pipefail

TIMEOUT="${SECURITY_VALIDATION_TIMEOUT:-300s}"
TEST_NAMESPACE="${SECURITY_TEST_NAMESPACE:-security-validation}"

log() {
  printf '[CHECK] %s\n' "$1"
}

fail() {
  printf '[FAIL] %s\n' "$1" >&2
  exit 1
}

cleanup() {
  kubectl delete namespace "${TEST_NAMESPACE}" \
    --ignore-not-found=true \
    --wait=false \
    >/dev/null 2>&1 || true
}

require_command() {
  command -v "$1" >/dev/null 2>&1 \
    || fail "Required command not found: $1"
}

expect_rejected() {
  local manifest="$1"
  local description="$2"

  if kubectl apply --dry-run=server -f "${manifest}" >/dev/null 2>&1; then
    fail "${description} was unexpectedly accepted."
  fi

  log "${description} correctly rejected."
}

main() {
  require_command kubectl
  trap cleanup EXIT

  log "Waiting for Kyverno admission controller"

  kubectl rollout status \
    deployment/kyverno-admission-controller \
    --namespace kyverno \
    --timeout "${TIMEOUT}"

  log "Waiting for Kyverno policies"

  kubectl wait \
    clusterpolicy \
    --all \
    --for=condition=Ready \
    --timeout "${TIMEOUT}"

  kubectl create namespace "${TEST_NAMESPACE}"

  kubectl label namespace "${TEST_NAMESPACE}" \
    security.platform.io/enforce=restricted \
    pod-security.kubernetes.io/enforce=restricted \
    --overwrite

  expect_rejected \
    validation/fixtures/security/privileged-pod.yaml \
    "Privileged pod"

  expect_rejected \
    validation/fixtures/security/latest-tag-pod.yaml \
    "Latest-tag pod"

  expect_rejected \
    validation/fixtures/security/missing-resources-pod.yaml \
    "Pod without resource controls"

  log "Security baseline validation passed."
}

main "$@"
