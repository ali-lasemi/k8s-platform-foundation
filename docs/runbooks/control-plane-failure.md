# Control Plane Failure Runbook

## Symptoms

Use this runbook when:

- the Kubernetes API is unavailable;
- kubectl cannot connect to the cluster;
- a k3s server repeatedly fails;
- etcd health prevents control-plane operation;
- multiple platform controllers become unreachable simultaneously.

## Safety

Do not initialize a new cluster or overwrite etcd state before determining
whether the existing control plane can be recovered.

Preserve available snapshots and logs before destructive recovery.

## Host checks

On the control-plane host:

    sudo systemctl status k3s

    sudo journalctl -u k3s -n 300 --no-pager

Check:

    df -h

    free -h

    uptime

Confirm network connectivity between control-plane nodes where applicable.

## Check k3s state

Inspect:

    sudo ls -lah /var/lib/rancher/k3s/server/db/

Confirm that snapshot data is available before attempting datastore recovery.

## Snapshot inventory

Use the repository snapshot verification tooling:

    ./backup/etcd/verify.sh

Identify the newest verified snapshot.

Record:

- snapshot timestamp;
- snapshot location;
- checksum result;
- affected control-plane node.

## Recovery decision

Prefer this order:

1. restart a recoverable k3s service;
2. repair host capacity or networking;
3. recover the failed server;
4. restore from a verified snapshot only when necessary.

## After API recovery

Run:

    kubectl get nodes

    kubectl get pods --all-namespaces

    flux get all --all-namespaces

Then run:

    ./validation/platform-health.sh

    ./validation/backup-health.sh

## GitOps recovery

After the Kubernetes API is stable, allow Flux to reconcile the desired state.

If required:

    flux reconcile source git flux-system \
      --namespace flux-system

Then reconcile affected Kustomizations individually.

## Recovery criteria

The control plane is considered recovered when:

- Kubernetes API requests succeed;
- expected nodes report Ready;
- system workloads are healthy;
- Flux reconciliation succeeds;
- backup health checks succeed;
- no unexpected datastore errors remain.
