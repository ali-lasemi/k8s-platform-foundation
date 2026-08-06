SHELL := /usr/bin/env bash

.PHONY: help security-validate install join uninstall validate smoke-test platform-health apply-foundation bootstrap-flux export-kubeconfig observability-validate

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
