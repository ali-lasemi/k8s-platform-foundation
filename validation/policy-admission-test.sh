#!/usr/bin/env bash

set -Eeuo pipefail

TEST_NAMESPACE="${POLICY_TEST_NAMESPACE:-policy-test}"
TIMEOUT="${POLICY_TEST_TIMEOUT:-300s}"

log() {
  printf '[CHECK] %s\n' "$1"
}

fail() {
  printf '[FAIL] %s\n' "$1" >&2
  exit 1
}

cleanup() {
  kubectl delete namespace "${TEST_NAMESPACE}" \
    --ignore-not-found \
    --wait=false \
    >/dev/null 2>&1 || true
}

trap cleanup EXIT

command -v kubectl >/dev/null 2>&1 \
  || fail "kubectl is required."

log "Waiting for Kyverno admission controller"

kubectl rollout status \
  deployment/kyverno-admission-controller \
  --namespace kyverno \
  --timeout "${TIMEOUT}"

log "Creating isolated policy test namespace"

kubectl create namespace "${TEST_NAMESPACE}"

kubectl label namespace "${TEST_NAMESPACE}" \
  pod-security.kubernetes.io/enforce=privileged \
  pod-security.kubernetes.io/audit=privileged \
  pod-security.kubernetes.io/warn=privileged \
  --overwrite

log "Applying compliant workload"

sed "s/namespace: platform-system/namespace: ${TEST_NAMESPACE}/" \
  policy-tests/fixtures/compliant/pod.yaml \
  | kubectl apply -f -

kubectl wait \
  pod/compliant-pod \
  --namespace "${TEST_NAMESPACE}" \
  --for=condition=Ready \
  --timeout "${TIMEOUT}"

log "Verifying privileged workload rejection"

if sed "s/namespace: platform-system/namespace: ${TEST_NAMESPACE}/" \
  policy-tests/fixtures/noncompliant/privileged-pod.yaml \
  | kubectl apply -f -; then
  fail "Privileged workload was unexpectedly accepted."
fi

log "Verifying latest-tag workload rejection"

if sed "s/namespace: platform-system/namespace: ${TEST_NAMESPACE}/" \
  policy-tests/fixtures/noncompliant/latest-tag-pod.yaml \
  | kubectl apply -f -; then
  fail "Latest-tag workload was unexpectedly accepted."
fi

log "Verifying missing-resource workload rejection"

if sed "s/namespace: platform-system/namespace: ${TEST_NAMESPACE}/" \
  policy-tests/fixtures/noncompliant/missing-resources-pod.yaml \
  | kubectl apply -f -; then
  fail "Workload without resource controls was unexpectedly accepted."
fi

log "Live admission policy validation passed."
