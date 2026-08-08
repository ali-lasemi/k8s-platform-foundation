# Progressive Delivery Flow

```mermaid
flowchart LR
    Git[Git Change]
    Flux[Flux]
    Deployment[Deployment]
    Flagger[Flagger]
    Primary[Primary Workload]
    Canary[Canary Workload]
    Traefik[Traefik]
    Prometheus[Prometheus]
    LoadTester[Load Tester]

    Git --> Flux
    Flux --> Deployment
    Deployment --> Flagger

    Flagger --> Primary
    Flagger --> Canary

    Traefik -->|Traffic split| Primary
    Traefik -->|Traffic split| Canary

    LoadTester --> Canary

    Primary -->|Metrics| Prometheus
    Canary -->|Metrics| Prometheus

    Prometheus -->|Success rate and latency| Flagger

    Flagger -->|Promote| Primary
    Flagger -->|Rollback on failure| Deployment
```

## Promotion decision

Flagger progressively shifts traffic toward the candidate release.

Prometheus metrics provide objective rollout gates.

Failed thresholds stop promotion and trigger rollback.

Successful analysis promotes the candidate version to primary.
