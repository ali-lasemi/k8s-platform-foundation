# Cluster Bootstrap

## Install the control plane

```bash
sudo ./bootstrap/install-k3s.sh
```

Override the pinned k3s version:

```bash
sudo K3S_VERSION="v1.36.1+k3s1" \
  ./bootstrap/install-k3s.sh
```

## Retrieve the worker token

Run on the control-plane node:

```bash
sudo cat /var/lib/rancher/k3s/server/node-token
```

## Join a worker node

```bash
sudo K3S_URL="https://CONTROL_PLANE_IP:6443" \
  K3S_TOKEN="REPLACE_WITH_NODE_TOKEN" \
  ./bootstrap/join-worker.sh
```

## Validate the cluster

```bash
./validation/cluster-health.sh
```

## Uninstall k3s

```bash
sudo ./bootstrap/uninstall.sh
```
