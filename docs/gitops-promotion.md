# Multi-Environment GitOps Promotion

## Overview

The platform models three deployment environments:

- development
- staging
- production

Each environment is composed from a shared Kustomize base and applies only the
configuration required for that environment.

## Promotion model

Changes move through the following path:

    development -> staging -> production

Promotion is represented as a Git change. Flux reconciles each environment from
the repository.

## Environment characteristics

### Development

Development uses the smallest resource footprint and is intended for early
validation.

### Staging

Staging uses additional replicas and is intended for release validation before
production promotion.

### Production

Production includes:

- three workload replicas;
- higher resource quotas;
- a PodDisruptionBudget;
- stricter operational expectations;
- explicit promotion from staging.

## Prepare a promotion

Development to staging:

    pwsh -File ./scripts/promote-environment.ps1 `
      -Promotion dev-to-staging `
      -Image traefik/whoami:v1.11.1

Staging to production:

    pwsh -File ./scripts/promote-environment.ps1 `
      -Promotion staging-to-production `
      -Image traefik/whoami:v1.11.1

The script modifies the target Kustomization only.

Review the generated Git diff before committing the promotion.

## Promotion rules

- `latest` image tags are rejected.
- Every environment must render successfully.
- Production changes must remain reviewable in Git.
- Development must be promoted before staging.
- Staging must be promoted before production.
- Production must retain its disruption and resource safeguards.

## Flux dependency chain

Flux reconciles:

    environment-dev
        |
        v
    environment-staging
        |
        v
    environment-production

This ordering prevents production reconciliation from racing ahead of lower
environments.

## Rollback

Rollback is Git-based.

1. Identify the last known-good production commit.
2. Revert the promotion commit.
3. Push the revert.
4. Reconcile the production Flux Kustomization.
5. Validate workload health.

Example:

    flux reconcile kustomization environment-production `
      --namespace flux-system `
      --with-source

## Validation

Run:

    pwsh -File ./validation/environment-promotion.ps1

CI also renders every environment and validates production safeguards.
