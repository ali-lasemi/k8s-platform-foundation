# Upgrade and Rollback Runbook

## Purpose

This runbook covers controlled k3s upgrades and rollback preparation.

## Pre-upgrade checks

Run:

    TARGET_VERSION=VERSION \
      ./operations/upgrade/preflight.sh

Confirm:

- all nodes are Ready;
- critical workloads are healthy;
- Flux reconciliation is healthy;
- recent etcd snapshots are valid;
- no active production incident exists.

## Create recovery point

Before upgrading:

    sudo ./backup/etcd/snapshot.sh

Then verify the resulting snapshot.

## Control-plane upgrade

Run:

    sudo TARGET_VERSION=VERSION \
      CONFIRM_UPGRADE=true \
      ./operations/upgrade/upgrade-server.sh

Validate:

    kubectl get nodes

    kubectl get pods --all-namespaces

    ./validation/platform-health.sh

## Worker upgrade

Drain the worker first:

    ./operations/nodes/drain-node.sh NODE_NAME

Upgrade:

    sudo TARGET_VERSION=VERSION \
      K3S_URL=SERVER_URL \
      K3S_TOKEN=NODE_TOKEN \
      CONFIRM_UPGRADE=true \
      ./operations/upgrade/upgrade-agent.sh

Validate:

    ./operations/nodes/validate-node.sh NODE_NAME

Return the node to service:

    ./operations/nodes/uncordon-node.sh NODE_NAME

## Rollback

Use rollback only after determining that the upgrade caused the failure and the
target rollback version is supported by the recovery plan.

Run:

    sudo ROLLBACK_VERSION=VERSION \
      CONFIRM_ROLLBACK=true \
      ./operations/upgrade/rollback-server.sh

If datastore compatibility prevents a safe binary rollback, use the documented
snapshot recovery procedure instead.

## Post-change validation

Run:

    ./validation/platform-health.sh

    ./validation/security-baseline.sh

    ./validation/observability-health.sh

    ./validation/backup-health.sh

    flux get all --all-namespaces

## Completion criteria

The upgrade is complete when:

- all expected nodes are Ready;
- platform workloads are healthy;
- Flux reconciliation is healthy;
- observability is healthy;
- backup validation succeeds;
- no new critical alerts remain.
