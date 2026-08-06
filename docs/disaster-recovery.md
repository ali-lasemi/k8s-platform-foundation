# Disaster Recovery

## Recovery objectives

The platform recovery workflow must support:

- rebuilding a control-plane node
- restoring the Kubernetes datastore
- replacing worker nodes
- reinstalling platform services through GitOps
- validating DNS, storage and ingress after recovery

## GitOps recovery

After restoring Kubernetes API access:

```bash
sudo ./scripts/bootstrap-flux.sh
```

Flux will reconcile the desired platform state from the `main` branch.

## Validation

```bash
make validate
make platform-health
make smoke-test
```

Datastore backup and restore automation will be added in the dedicated
disaster-recovery phase.