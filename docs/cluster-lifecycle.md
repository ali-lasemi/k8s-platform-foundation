# Cluster Lifecycle Operations

## Drain a node

```bash
make node-drain NODE=worker-01
```

## Return a node to service

```bash
make node-uncordon NODE=worker-01
```

## Remove a worker node

```bash
make node-remove NODE=worker-01
```

## Validate a node

```bash
make node-validate NODE=worker-01
```

## Upgrade preflight

```bash
make upgrade-preflight VERSION=v1.36.2+k3s1
```

## Upgrade the control plane

```bash
make upgrade-server VERSION=v1.36.2+k3s1
```

## Upgrade a worker

```bash
make upgrade-agent \
  VERSION=v1.36.2+k3s1 \
  K3S_URL=https://CONTROL_PLANE_IP:6443 \
  K3S_TOKEN=REPLACE_WITH_NODE_TOKEN
```

## Roll back the control plane

```bash
make rollback-server VERSION=v1.36.1+k3s1
```

## Rotate certificates

```bash
sudo CONFIRM_ROTATION=true \
  ./operations/certificates/rotate-k3s-certificates.sh
```

## Validate certificate expiry

```bash
sudo ./operations/certificates/check-expiry.sh
```
