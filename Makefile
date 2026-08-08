SHELL := /usr/bin/env bash

.PHONY: help security-validate install join uninstall validate smoke-test platform-health apply-foundation bootstrap-flux export-kubeconfig observability-validate backup-create backup-verify backup-install-timer velero-validate backup-live-test dr-validate node-drain node-uncordon node-remove node-validate upgrade-preflight upgrade-server upgrade-agent rollback-server certificate-rotate certificate-check lifecycle-validate sops-validate sops-generate-key sops-update-recipient sops-bootstrap sops-rotate ingress-dns-validate ingress-dns-health policy-test policy-test-validate policy-admission-test environment-validate promote-dev-staging promote-staging-production architecture-validate runbooks-validate production-readiness release-gates release-version-validate release-checklist release-e2e

help:
@echo "Available targets:"
@echo "  make install              Install the k3s control plane"
@echo "  make join                 Join a worker node"
@echo "  make uninstall            Remove k3s"
@echo "  make validate             Validate cluster health"
@echo "  make smoke-test           Run DNS and storage smoke tests"
@echo "  make platform-health      Validate platform services"
@echo "  make apply-foundation     Apply the cluster foundation"
@echo "  make bootstrap-flux       Install and configure Flux"
@echo "  make export-kubeconfig    Export the k3s kubeconfig"

install:
sudo ./bootstrap/install-k3s.sh

join:
sudo ./bootstrap/join-worker.sh

uninstall:
sudo ./bootstrap/uninstall.sh

validate:
./validation/cluster-health.sh

smoke-test:
./validation/smoke-test.sh

platform-health:
./validation/platform-health.sh

apply-foundation:
kubectl apply -k clusters/homelab

bootstrap-flux:
sudo ./scripts/bootstrap-flux.sh

export-kubeconfig:
sudo ./scripts/export-kubeconfig.sh
security-validate:
./validation/security-baseline.sh
observability-validate:
./validation/observability-health.sh
backup-create:
sudo ./backup/etcd/snapshot.sh

backup-verify:
sudo ./validation/backup-health.sh

backup-install-timer:
sudo ./backup/etcd/install-systemd.sh
velero-validate:
./validation/velero-health.sh
backup-live-test:
./backup/velero/backup-check.sh

dr-validate:
./validation/disaster-recovery.sh
node-drain:
./operations/nodes/drain-node.sh "$(NODE)"

node-uncordon:
./operations/nodes/uncordon-node.sh "$(NODE)"

node-remove:
CONFIRM_REMOVE=true ./operations/nodes/remove-worker.sh "$(NODE)"

node-validate:
./operations/nodes/validate-node.sh "$(NODE)"
upgrade-preflight:
TARGET_VERSION="$(VERSION)" ./operations/upgrade/preflight.sh

upgrade-server:
sudo TARGET_VERSION="$(VERSION)" CONFIRM_UPGRADE=true ./operations/upgrade/upgrade-server.sh

upgrade-agent:
sudo TARGET_VERSION="$(VERSION)" K3S_URL="$(K3S_URL)" K3S_TOKEN="$(K3S_TOKEN)" CONFIRM_UPGRADE=true ./operations/upgrade/upgrade-agent.sh

rollback-server:
sudo ROLLBACK_VERSION="$(VERSION)" CONFIRM_ROLLBACK=true ./operations/upgrade/rollback-server.sh
certificate-rotate:
sudo CONFIRM_ROTATION=true ./operations/certificates/rotate-k3s-certificates.sh

certificate-check:
sudo ./operations/certificates/check-expiry.sh

lifecycle-validate:
./validation/lifecycle-operations.sh
sops-validate:
pwsh -File ./validation/sops-foundation.ps1
pwsh -File ./validation/encrypted-secrets.ps1

sops-generate-key:
pwsh -File ./scripts/generate-age-key.ps1

sops-update-recipient:
pwsh -File ./scripts/update-sops-age-recipient.ps1

sops-bootstrap:
pwsh -File ./scripts/bootstrap-sops-age.ps1
sops-rotate:
pwsh -File ./scripts/rotate-sops-age-key.ps1 -NewRecipient "$(AGE_RECIPIENT)"
ingress-dns-validate:
pwsh -File ./validation/ingress-dns-static.ps1

ingress-dns-health:
./validation/ingress-dns-health.sh
policy-test:
kyverno test policy-tests

policy-test-validate:
pwsh -File ./validation/policy-tests.ps1

policy-admission-test:
./validation/policy-admission-test.sh
environment-validate:
pwsh -File ./validation/environment-promotion.ps1

promote-dev-staging:
pwsh -File ./scripts/promote-environment.ps1 -Promotion dev-to-staging -Image "$(IMAGE)"

promote-staging-production:
pwsh -File ./scripts/promote-environment.ps1 -Promotion staging-to-production -Image "$(IMAGE)"
architecture-validate:
pwsh -File ./validation/architecture-docs.ps1
runbooks-validate:
pwsh -File ./validation/runbooks.ps1
production-readiness:
pwsh -File ./validation/production-readiness.ps1
release-gates:
pwsh -File ./validation/release-gates.ps1
release-version-validate:
pwsh -File ./validation/release-version.ps1
release-checklist:
pwsh -File ./validation/release-checklist.ps1
release-e2e:
pwsh -File ./validation/release-e2e.ps1
