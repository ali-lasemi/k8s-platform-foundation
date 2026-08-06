# Networking

## Components

The platform networking layer consists of:

- MetalLB for bare-metal `LoadBalancer` services
- Traefik for HTTP and HTTPS ingress
- Kubernetes NetworkPolicy resources
- CoreDNS for service discovery

## MetalLB configuration

MetalLB is installed without an address pool because the correct address range
depends on the physical network.

Create a cluster-specific address pool only after reserving a range outside the
DHCP allocation range.

Example:

```yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: production-pool
  namespace: metallb-system
spec:
  addresses:
    - 192.168.10.200-192.168.10.220
```

Do not copy the example range without confirming the local network layout.

## Traffic flow

```text
Client
  |
  v
MetalLB LoadBalancer IP
  |
  v
Traefik
  |
  v
Kubernetes Service
  |
  v
Application Pods
```
