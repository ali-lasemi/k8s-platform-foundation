# Observability Failure Runbook

## Symptoms

Use this runbook when:

- Grafana dashboards stop receiving data;
- Prometheus targets disappear;
- Loki queries fail;
- logs stop arriving;
- alert rules stop evaluating;
- progressive delivery cannot query metrics.

## Check observability workloads

    kubectl get pods \
      --namespace observability

Inspect deployments and StatefulSets:

    kubectl get deployment,statefulset \
      --namespace observability

## Prometheus

Check Prometheus resources:

    kubectl get prometheus \
      --namespace observability

    kubectl get servicemonitor \
      --all-namespaces

    kubectl get prometheusrule \
      --all-namespaces

Inspect Prometheus logs:

    kubectl logs \
      --namespace observability \
      statefulset/prometheus-kube-prometheus-stack-prometheus \
      --tail=200

## Grafana

    kubectl get pods \
      --namespace observability \
      -l app.kubernetes.io/name=grafana

Review logs for the active Grafana pod.

## Loki and Alloy

    kubectl get pods \
      --namespace observability \
      -l app.kubernetes.io/name=loki

    kubectl get pods \
      --namespace observability \
      -l app.kubernetes.io/name=alloy

Review Loki and Alloy logs for:

- connection failures;
- rejected log batches;
- storage errors;
- configuration errors.

## Flux status

    flux get kustomization observability \
      --namespace flux-system

If required:

    flux reconcile kustomization observability \
      --namespace flux-system \
      --with-source

## Validate

Run:

    ./validation/observability-health.sh

## Recovery criteria

Recovery is complete when:

- Prometheus is Ready;
- expected scrape targets are available;
- Grafana can query Prometheus;
- Alloy forwards logs;
- Loki accepts and returns queries;
- alert rules are loaded;
- Flagger metric queries work again.
