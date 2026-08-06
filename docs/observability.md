# Observability

## Components

- Prometheus for metrics and recording rules
- Alertmanager for alert routing
- Grafana for dashboards and exploration
- Loki for centralized Kubernetes logs
- Grafana Alloy for node-level log collection
- kube-state-metrics for Kubernetes object metrics
- Node Exporter for host metrics

## Metrics retention

Prometheus retains metrics for 15 days with a maximum target size of 45 GB.

## Log retention

Loki retains logs for seven days.

## Validation

```bash
make observability-validate
```

## Access Grafana

```bash
kubectl port-forward \
  --namespace observability \
  service/kube-prometheus-stack-grafana \
  3000:80
```

Open:

```text
http://127.0.0.1:3000
```

Grafana credentials must be supplied through the `grafana-admin` Secret before
the Helm release is reconciled.

## Required secret

```bash
kubectl create secret generic grafana-admin \
  --namespace observability \
  --from-literal=admin-user=admin \
  --from-literal=admin-password='REPLACE_WITH_STRONG_PASSWORD'
```

Do not commit this credential.
