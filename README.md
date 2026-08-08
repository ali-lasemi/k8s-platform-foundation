# k8s-platform-foundation

Production-oriented Kubernetes foundation for reproducible self-hosted platforms using k3s.

## Capabilities

- Reproducible and version-pinned k3s installation
- Control-plane and worker-node bootstrap
- Safe uninstall workflow
- Cluster health validation
- ShellCheck and YAML validation in CI
- Consistent UTF-8 and LF line endings
- GitOps-ready repository structure

## Requirements

- Ubuntu or Debian Linux
- Root or sudo access
- systemd
- curl
- Network connectivity between cluster nodes

## Install control plane

```bash
make install
```

## Join a worker node

```bash
export K3S_URL="https://CONTROL_PLANE_IP:6443"
export K3S_TOKEN="REPLACE_WITH_NODE_TOKEN"

make join
```

## Validate the cluster

```bash
make validate
```

## Uninstall

```bash
make uninstall
```

## Roadmap

- Ingress and load balancing
- Automated TLS
- GitOps with Flux
- Secrets management
- Observability
- Kubernetes security policies
- Backup and disaster recovery
- Failure-recovery scenarios
## Architecture

The platform architecture is documented with version-controlled Mermaid
diagrams.

Key diagrams:

- [Platform overview](docs/architecture/platform-overview.md)
- [Component map](docs/architecture/component-map.md)
- [GitOps flow](docs/architecture/gitops-flow.md)
- [Ingress, DNS and TLS flow](docs/architecture/traffic-flow.md)
- [Observability flow](docs/architecture/observability-flow.md)
- [Encrypted secrets flow](docs/architecture/secrets-flow.md)
- [Disaster recovery flow](docs/architecture/disaster-recovery-flow.md)
- [Progressive delivery flow](docs/architecture/progressive-delivery-flow.md)
- [Environment promotion flow](docs/architecture/environment-promotion-flow.md)

See the complete architecture index in
[docs/architecture/README.md](docs/architecture/README.md).
