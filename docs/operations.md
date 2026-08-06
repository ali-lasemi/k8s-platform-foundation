# Operations

## Validate cluster health

```bash
make validate
```

## Run end-to-end smoke tests

```bash
make smoke-test
```

The smoke test validates:

- Kubernetes DNS resolution
- Pod scheduling
- Container networking
- Dynamic persistent-volume provisioning

## Export kubeconfig

Run on the control-plane node:

```bash
sudo SERVER_ADDRESS="CONTROL_PLANE_IP" \
  OUTPUT_KUBECONFIG="/home/USER/.kube/config" \
  ./scripts/export-kubeconfig.sh
```

## Inspect platform status

```bash
kubectl get nodes -o wide
kubectl get pods --all-namespaces
kubectl get storageclass
kubectl get events --all-namespaces \
  --sort-by='.metadata.creationTimestamp'
```