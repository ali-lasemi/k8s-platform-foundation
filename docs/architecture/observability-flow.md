# Observability Data Flow

```mermaid
flowchart LR
    Nodes[Kubernetes Nodes]
    Workloads[Platform Workloads]
    Traefik[Traefik]
    Flagger[Flagger]

    Alloy[Grafana Alloy]
    Prometheus[Prometheus]
    Loki[Loki]
    Grafana[Grafana]
    Alerts[Platform Alerts]

    Nodes -->|Metrics| Prometheus
    Workloads -->|Metrics| Prometheus
    Traefik -->|Metrics| Prometheus
    Flagger -->|Analysis queries| Prometheus

    Nodes -->|Logs| Alloy
    Workloads -->|Logs| Alloy
    Alloy -->|Log streams| Loki

    Prometheus --> Grafana
    Loki --> Grafana

    Prometheus --> Alerts
```

## Telemetry model

Prometheus collects infrastructure and application metrics.

Grafana Alloy forwards platform and workload logs to Loki.

Grafana provides a unified interface for metrics and logs.

Flagger queries Prometheus during progressive delivery to determine whether a
release should be promoted or rolled back.
