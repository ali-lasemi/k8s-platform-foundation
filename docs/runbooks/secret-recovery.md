# Secret Recovery Runbook

## Symptoms

Use this runbook when:

- Flux reports SOPS decryption failures;
- the `sops-age` Secret is missing;
- encrypted manifests stop reconciling;
- an Age key must be rotated;
- a recovered cluster cannot decrypt Git-managed Secrets.

## Initial checks

    kubectl get secret sops-age \
      --namespace flux-system

    kubectl get kustomization encrypted-secrets \
      --namespace flux-system

    kubectl describe kustomization encrypted-secrets \
      --namespace flux-system

    flux get kustomizations \
      --all-namespaces

## Restore the Age private key

Run from a trusted workstation that contains the backed-up private key:

    pwsh -File ./scripts/bootstrap-sops-age.ps1 `
      -KeyPath "$HOME\.config\sops\age\keys.txt"

Never copy the private key into Git.

## Reconcile encrypted Secrets

    flux reconcile kustomization encrypted-secrets `
      --namespace flux-system `
      --with-source

## Validate

    kubectl get secrets \
      --namespace platform-secrets

    pwsh -File ./validation/sops-foundation.ps1

    pwsh -File ./validation/encrypted-secrets.ps1

## Rotation

Before retiring an old Age key:

- generate a new key pair;
- securely back up the private key;
- update all SOPS recipients;
- bootstrap the new private key into Flux;
- confirm every encrypted manifest decrypts successfully;
- test recovery using the new key.

## Recovery criteria

Recovery is complete when:

- Flux can decrypt all encrypted manifests;
- affected Secrets exist;
- dependent workloads become healthy;
- the new or restored private key has a secure backup.
