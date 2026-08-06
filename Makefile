SHELL := /usr/bin/env bash

.PHONY: help install join uninstall validate smoke-test apply-foundation export-kubeconfig

help:
@echo "Available targets:"
@echo "  make install              Install the k3s control plane"
@echo "  make join                 Join a worker node"
@echo "  make uninstall            Remove k3s"
@echo "  make validate             Validate cluster health"
@echo "  make smoke-test           Run DNS and storage smoke tests"
@echo "  make apply-foundation     Apply namespaces and network policies"
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

apply-foundation:
kubectl apply -k cluster/namespaces
kubectl apply -k cluster/network

export-kubeconfig:
sudo ./scripts/export-kubeconfig.sh