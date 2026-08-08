# Platform Architecture Overview

```mermaid
flowchart TB
    Engineer[Platform Engineer]
    GitHub[GitHub Repository]
    Flux[Flux GitOps Controllers]

    subgraph Platform["Self-Hosted Kubernetes Platform"]
        Traefik[Traefik]
        CertManager[cert-manager]
        ExternalDNS[ExternalDNS]
        Kyverno[Kyverno]
        Flagger[Flagger]
        Prometheus[Prometheus]
        Grafana[Grafana]
        Loki[Loki]
        Alloy[Grafana Alloy]
        Velero[Velero]
        Workloads[Platform Workloads]
    end

    Cloudflare[Cloudflare DNS]
    LetsEncrypt[Let's Encrypt]
    BackupStorage[Backup Object Storage]

    Engineer -->|Git changes| GitHub
    GitHub -->|Desired state| Flux

    Flux --> Traefik
    Flux --> CertManager
    Flux --> ExternalDNS
    Flux --> Kyverno
    Flux --> Flagger
    Flux --> Prometheus
    Flux --> Grafana
    Flux --> Loki
    Flux --> Alloy
    Flux --> Velero
    Flux --> Workloads

    ExternalDNS -->|DNS records| Cloudflare
    CertManager -->|ACME| LetsEncrypt
    Velero -->|Backups| BackupStorage

    Traefik -->|Ingress traffic| Workloads
    Flagger -->|Progressive delivery| Workloads

    Workloads -->|Metrics| Prometheus
    Workloads -->|Logs| Alloy
    Alloy --> Loki
    Prometheus --> Grafana
    Loki --> Grafana

    Kyverno -->|Admission policies| Workloads
```

## Architecture principles

The platform is designed around the following principles:

- Git is the source of truth.
- Flux continuously reconciles desired state.
- Kubernetes resources are declarative and reproducible.
- Secrets are encrypted with SOPS and Age.
- Kyverno enforces security policy as code.
- Flagger controls progressive delivery.
- Prometheus, Grafana, Loki and Alloy provide observability.
- Velero and k3s snapshots provide recovery capabilities.
- Environment promotion is performed through Git changes.
- Manual cluster changes are reserved for bootstrap, recovery and diagnostics.
