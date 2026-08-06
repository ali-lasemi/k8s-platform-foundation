# Disaster Recovery Runbook

## Control-plane failure

1. Provision a replacement Linux host.
2. Install the same pinned k3s version.
3. Copy the verified snapshot to the replacement node.
4. Run the guarded restore command.
5. Reinstall Flux.
6. Wait for platform reconciliation.
7. Run all validation targets.

## Accidental namespace deletion

1. Confirm the deletion event.
2. Pause conflicting GitOps reconciliation when necessary.
3. Identify the latest successful Velero backup.
4. Restore only the affected namespace.
5. Resume GitOps reconciliation.
6. Validate workload readiness, storage and networking.

## Recovery checks

```bash
make validate
make platform-health
make security-validate
make observability-validate
make velero-validate
make smoke-test
```

## Recovery evidence

Capture:

- snapshot checksum result
- Velero backup and restore status
- Kubernetes events
- Flux reconciliation status
- node and pod readiness
- storage and DNS smoke-test results
