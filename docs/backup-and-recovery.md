# Backup and Recovery

## Layers

The platform uses two backup layers:

- k3s etcd snapshots for control-plane state
- Velero for Kubernetes resources and persistent-volume file backups

## Create an etcd snapshot

```bash
make backup-create
```

## Verify the latest etcd snapshot

```bash
make backup-verify
```

## Install the automated snapshot timer

```bash
make backup-install-timer
```

## Velero credentials

Create the required object-storage credentials before reconciliation:

```bash
kubectl create namespace velero

kubectl create secret generic velero-credentials \
  --namespace velero \
  --from-file=cloud=credentials-velero
```

## Restore etcd

```bash
sudo CONFIRM_RESTORE=true \
  ./backup/etcd/restore.sh \
  /var/lib/rancher/k3s/server/db/snapshots/SNAPSHOT_FILE
```

## Recovery validation

After restore:

```bash
make validate
make platform-health
make security-validate
make observability-validate
make smoke-test
```
