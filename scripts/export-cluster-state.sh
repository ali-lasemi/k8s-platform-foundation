#!/usr/bin/env bash

set -Eeuo pipefail

mkdir -p /tmp/k8s-platform

kubectl get nodes -o wide > /tmp/k8s-platform/nodes.txt

kubectl get pods -A -o wide > /tmp/k8s-platform/pods.txt

kubectl get svc -A > /tmp/k8s-platform/services.txt

kubectl get events -A \
--sort-by=.metadata.creationTimestamp \
> /tmp/k8s-platform/events.txt

kubectl version > /tmp/k8s-platform/version.txt