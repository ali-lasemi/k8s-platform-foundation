SHELL := /usr/bin/env bash

.PHONY: help install join uninstall validate

help:
@echo "Available targets:"
@echo "  make install    Install k3s server"
@echo "  make join       Join a worker node"
@echo "  make uninstall  Remove k3s"
@echo "  make validate   Validate cluster health"

install:
sudo ./bootstrap/install-k3s.sh

join:
sudo ./bootstrap/join-worker.sh

uninstall:
sudo ./bootstrap/uninstall.sh

validate:
./validation/cluster-health.sh
