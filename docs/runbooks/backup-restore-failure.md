# Backup and Restore Failure Runbook

## Symptoms

Use this runbook when:

- scheduled etcd snapshots stop appearing;
- snapshot checksum validation fails;
- Velero backups fail;
- object storage becomes unavailable;
- restore operations fail;
- recovery-point objectives are at risk.

## Check etcd snapshots

On the control-plane host:

    sudo ls -lah \
      /var/lib/rancher/k3s/server/db/snapshots

Run:

    sudo ./validation/backup-health.sh

Check the snapshot timer:

    sudo systemctl status \
      k3s-etcd-snapshot.timer

Check the most recent service execution:

    sudo systemctl status \
      k3s-etcd-snapshot.service

## Validate snapshot integrity

Use:

    sudo ./backup/etcd/verify.sh \
      SNAPSHOT_PATH

Do not restore from a snapshot that fails checksum validation.

## Check Velero

    kubectl get pods \
      --namespace velero

    kubectl get backup \
      --namespace velero

    kubectl get schedule \
      --namespace velero

    kubectl get backupstoragelocation \
      --namespace velero

Inspect failures:

    kubectl describe backup BACKUP_NAME \
      --namespace velero

    kubectl logs deployment/velero \
      --namespace velero \
      --tail=200

## Storage failure

If the BackupStorageLocation is unavailable:

- verify object storage reachability;
- verify endpoint configuration;
- verify credentials;
- avoid deleting local recovery data;
- restore storage access before retrying backups.

## Restore safety

Before performing a destructive restore:

- identify the exact recovery point;
- validate its checksum;
- record the current cluster state;
- confirm the expected blast radius;
- confirm the restore target.

Use the repository disaster recovery documentation for full restore procedures.

## Validation

Run:

    ./validation/backup-health.sh

    ./validation/velero-health.sh

    ./validation/disaster-recovery.sh

## Recovery criteria

Recovery is complete when:

- a recent verified etcd snapshot exists;
- Velero BackupStorageLocation reports Available;
- scheduled backups succeed;
- restore procedures are testable;
- recovery evidence is captured.
