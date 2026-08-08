# Production Operations Runbooks

This directory contains actionable operational procedures for the Kubernetes
platform.

## Incident management

- [Incident response](incident-response.md)
- [Severity model](severity-model.md)
- [Initial incident triage](initial-triage.md)
- [On-call handover](on-call-handover.md)
- [Post-incident review](post-incident-review.md)

## Cluster and GitOps failures

- [Node failure](node-failure.md)
- [Control-plane failure](control-plane-failure.md)
- [Flux reconciliation failure](flux-reconciliation-failure.md)

## Platform service failures

- [Ingress, TLS and DNS failure](ingress-tls-dns-failure.md)
- [Observability failure](observability-failure.md)
- [Backup and restore failure](backup-restore-failure.md)
- [Secret recovery](secret-recovery.md)

## Maintenance

- [Upgrade and rollback](upgrade-rollback.md)

Every runbook is intended to prioritize reversible actions, evidence capture and
explicit recovery validation.
