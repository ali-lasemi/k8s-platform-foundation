# Flux Reconciliation Failure Runbook

## Symptoms

Use this runbook when:

- a Flux Kustomization reports `False`;
- a HelmRelease is stalled;
- GitRepository reconciliation fails;
- dependencies block downstream reconciliation;
- the cluster differs from expected Git state.

## Check Flux status

    flux get sources git --all-namespaces

    flux get kustomizations --all-namespaces

    flux get helmreleases --all-namespaces

Identify the first failed dependency rather than only investigating downstream
failures.

## Inspect the failed resource

For a Kustomization:

    flux get kustomization NAME \
      --namespace flux-system

    kubectl describe kustomization NAME \
      --namespace flux-system

For a HelmRelease:

    flux get helmrelease NAME \
      --namespace NAMESPACE

    kubectl describe helmrelease NAME \
      --namespace NAMESPACE

## Check controller logs

    kubectl logs \
      --namespace flux-system \
      deployment/source-controller \
      --tail=200

    kubectl logs \
      --namespace flux-system \
      deployment/kustomize-controller \
      --tail=200

    kubectl logs \
      --namespace flux-system \
      deployment/helm-controller \
      --tail=200

## Common causes

Check for:

- invalid YAML;
- failed Kustomize rendering;
- unavailable Helm repositories;
- missing CRDs;
- dependency ordering problems;
- SOPS decryption errors;
- policy admission failures;
- immutable Kubernetes field changes;
- unavailable external dependencies.

## Reconcile source

After fixing the underlying problem:

    flux reconcile source git flux-system \
      --namespace flux-system

## Reconcile Kustomization

    flux reconcile kustomization NAME \
      --namespace flux-system \
      --with-source

## Rollback

If a recent Git change caused the failure:

    git log --oneline -10

Revert the problematic commit:

    git revert COMMIT_SHA

Push the revert and allow Flux to reconcile.

Avoid manually changing managed Kubernetes resources because Flux may overwrite
those changes.

## Recovery criteria

Recovery is complete when:

- GitRepository is Ready;
- required Kustomizations are Ready;
- HelmReleases are Ready;
- dependent reconciliations recover;
- workloads are healthy;
- no unexplained configuration drift remains.
