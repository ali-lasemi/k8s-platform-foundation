# Platform Architecture

This directory contains version-controlled architecture documentation for the
Kubernetes platform foundation.

## Core architecture

- [Platform architecture overview](platform-overview.md)
- [Platform component map](component-map.md)
- [GitOps reconciliation flow](gitops-flow.md)

## Platform flows

- [Ingress, DNS and TLS traffic flow](traffic-flow.md)
- [Observability data flow](observability-flow.md)
- [Encrypted secrets flow](secrets-flow.md)
- [Backup and disaster recovery flow](disaster-recovery-flow.md)
- [Progressive delivery flow](progressive-delivery-flow.md)
- [Multi-environment promotion flow](environment-promotion-flow.md)

## Documentation principles

Architecture diagrams are stored beside the platform code and should evolve
with implementation changes.

The diagrams describe system boundaries, control flow, data flow and recovery
paths rather than implementation details that are likely to change frequently.
