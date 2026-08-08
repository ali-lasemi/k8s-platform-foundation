# Platform Component Map

```mermaid
flowchart LR
    subgraph GitOps
        FluxSource[Source Controller]
        FluxKustomize[Kustomize Controller]
        FluxHelm[Helm Controller]
    end

    subgraph Networking
        MetalLB[MetalLB]
        Traefik[Traefik]
        ExternalDNS[ExternalDNS]
        CertManager[cert-manager]
    end

    subgraph Security
        Kyverno[Kyverno]
        SOPS[SOPS + Age]
    end

    subgraph Delivery
        Flagger[Flagger]
        LoadTester[Flagger Loadtester]
    end

    subgraph Observability
        Prometheus[Prometheus]
        Grafana[Grafana]
        Loki[Loki]
        Alloy[Alloy]
    end

    subgraph Recovery
        Velero[Velero]
        EtcdSnapshots[k3s etcd snapshots]
    end

    FluxSource --> FluxKustomize
    FluxSource --> FluxHelm

    FluxKustomize --> Networking
    FluxKustomize --> Security
    FluxKustomize --> Delivery
    FluxKustomize --> Observability
    FluxKustomize --> Recovery

    FluxHelm --> MetalLB
    FluxHelm --> Traefik
    FluxHelm --> ExternalDNS
    FluxHelm --> CertManager
    FluxHelm --> Kyverno
    FluxHelm --> Flagger
    FluxHelm --> Prometheus
    FluxHelm --> Grafana
    FluxHelm --> Loki
    FluxHelm --> Alloy
    FluxHelm --> Velero

    SOPS --> FluxKustomize
    Prometheus --> Flagger
    LoadTester --> Flagger
```

## Responsibility boundaries

GitOps controllers manage reconciliation.

Networking components expose workloads and automate DNS and TLS.

Security components protect admission and encrypted configuration.

Progressive delivery components control rollout promotion and rollback.

Observability components provide metrics, dashboards and centralized logs.

Recovery components protect Kubernetes state and application resources.
