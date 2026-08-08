# Environment Promotion Runbook

## Pre-promotion checks

Before promoting:

- confirm the source environment is healthy;
- confirm CI is green;
- confirm the image uses an immutable version tag;
- review release notes;
- confirm no unresolved incident affects the target environment.

## Development to staging

Prepare:

    pwsh -File ./scripts/promote-environment.ps1 `
      -Promotion dev-to-staging `
      -Image IMAGE_REFERENCE

Validate:

    kubectl kustomize environments/staging

Review:

    git diff

Commit only after validation succeeds.

## Staging to production

Prepare:

    pwsh -File ./scripts/promote-environment.ps1 `
      -Promotion staging-to-production `
      -Image IMAGE_REFERENCE

Validate:

    kubectl kustomize environments/production

Review:

    git diff

Confirm production still includes:

- three replicas;
- resource quota;
- PodDisruptionBudget.

## Post-promotion checks

    flux get kustomizations

    kubectl get deployment \
      --namespace platform-production

    kubectl get pods \
      --namespace platform-production

    kubectl get pdb \
      --namespace platform-production

## Rollback

If production becomes unhealthy:

1. revert the promotion commit;
2. push the revert;
3. force Flux reconciliation;
4. confirm deployment rollout;
5. verify application health.

Run:

    flux reconcile kustomization environment-production `
      --namespace flux-system `
      --with-source

## Evidence

Capture:

- promoted image version;
- source commit;
- target commit;
- CI result;
- Flux reconciliation result;
- production rollout status;
- rollback result if used.
