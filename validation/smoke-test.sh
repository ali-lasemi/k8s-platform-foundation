#!/usr/bin/env bash

set -Eeuo pipefail

NAMESPACE="${SMOKE_TEST_NAMESPACE:-platform-smoke-test}"
TIMEOUT="${SMOKE_TEST_TIMEOUT:-180s}"

log() {
  printf '[CHECK] %s\n' "$1"
}

cleanup() {
  kubectl delete namespace "${NAMESPACE}" \
    --ignore-not-found=true \
    --wait=false \
    >/dev/null 2>&1 || true
}

fail() {
  printf '[FAIL] %s\n' "$1" >&2
  cleanup
  exit 1
}

require_command() {
  command -v "$1" >/dev/null 2>&1 ||
    fail "Required command not found: $1"
}

main() {
  require_command kubectl
  trap cleanup EXIT

  log "Creating smoke-test namespace"
  kubectl create namespace "${NAMESPACE}"

  log "Deploying DNS and networking test pod"
  kubectl run dns-check \
    --namespace "${NAMESPACE}" \
    --image=busybox:1.36.1 \
    --restart=Never \
    --command -- \
    sh -c 'nslookup kubernetes.default.svc.cluster.local'

  kubectl wait \
    --namespace "${NAMESPACE}" \
    --for=jsonpath='{.status.phase}'=Succeeded \
    pod/dns-check \
    --timeout="${TIMEOUT}" ||
    fail "DNS smoke test failed."

  log "Testing dynamic persistent storage"
  cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: storage-check
  namespace: ${NAMESPACE}
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 64Mi
---
apiVersion: v1
kind: Pod
metadata:
  name: storage-check
  namespace: ${NAMESPACE}
spec:
  restartPolicy: Never
  containers:
    - name: storage-check
      image: busybox:1.36.1
      command:
        - sh
        - -c
        - echo platform-ready > /data/status
      volumeMounts:
        - name: data
          mountPath: /data
  volumes:
    - name: data
      persistentVolumeClaim:
        claimName: storage-check
EOF

  kubectl wait \
    --namespace "${NAMESPACE}" \
    --for=jsonpath='{.status.phase}'=Succeeded \
    pod/storage-check \
    --timeout="${TIMEOUT}" ||
    fail "Storage smoke test failed."

  log "Cluster smoke tests passed."
}

main "$@"