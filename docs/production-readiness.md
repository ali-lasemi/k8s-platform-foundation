# Production Readiness

## Purpose

This document defines the final readiness gates for the first stable platform
release.

The repository is considered release-ready only when the platform foundation,
security controls, GitOps workflows, operational documentation and automated
validation are complete.

## Readiness areas

### Platform foundation

- k3s bootstrap and lifecycle operations
- namespace and network policy foundation
- Flux GitOps reconciliation
- ingress and load-balancing foundation
- TLS and DNS automation

### Security

- Kyverno policy enforcement
- policy regression tests
- encrypted GitOps Secrets
- secret rotation and recovery
- security scanning workflows

### Reliability

- cluster lifecycle operations
- backup and restore automation
- disaster recovery procedures
- progressive delivery
- production disruption safeguards

### Observability

- Prometheus
- Grafana
- Loki
- Grafana Alloy
- platform alerting
- rollout metrics

### Delivery

- development environment
- staging environment
- production environment
- Git-based promotion
- rollback procedures
- Flux reconciliation

### Operations

- incident response
- severity classification
- failure-specific runbooks
- on-call handover
- post-incident review

### Documentation

- platform architecture
- GitOps flows
- traffic flows
- observability flows
- security flows
- recovery flows
- operational runbooks

## Release gate

Before publishing a stable release:

1. Run all GitHub Actions.
2. Validate all Kustomize overlays.
3. Validate Kubernetes manifests.
4. Run security policy tests.
5. Run repository integration tests.
6. Validate architecture documentation.
7. Validate production runbooks.
8. Review known limitations.
9. Review the release changelog.
10. Confirm the release commit is clean and reproducible.

The stable release must not be published while a required validation gate is
failing.
