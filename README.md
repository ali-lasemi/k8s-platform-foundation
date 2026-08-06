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