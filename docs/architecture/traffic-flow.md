# Ingress, DNS and TLS Traffic Flow

```mermaid
flowchart LR
    User[External User]
    DNS[Cloudflare DNS]
    LB[MetalLB]
    Traefik[Traefik Ingress]
    Middleware[Security Middleware]
    Service[Kubernetes Service]
    Pod[Application Pods]
    ExternalDNS[ExternalDNS]
    CertManager[cert-manager]
    LetsEncrypt[Let's Encrypt]

    ExternalDNS -->|Create or update records| DNS
    CertManager -->|ACME challenge| LetsEncrypt
    LetsEncrypt -->|Certificate| CertManager

    User -->|DNS lookup| DNS
    DNS -->|Service address| User
    User -->|HTTPS| LB
    LB --> Traefik
    Traefik --> Middleware
    Middleware --> Service
    Service --> Pod

    CertManager -->|TLS Secret| Traefik
```

## Request path

Public traffic resolves through Cloudflare DNS and reaches the Kubernetes
LoadBalancer address managed by MetalLB.

Traefik terminates TLS and applies platform middleware before forwarding traffic
to application Services.

ExternalDNS manages DNS records from Kubernetes resources.

cert-manager manages certificate lifecycle through Let's Encrypt.
