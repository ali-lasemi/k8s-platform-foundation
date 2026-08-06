# Secrets Recovery Runbook

## Trigger conditions

Use this runbook when:

- Flux reports SOPS decryption failures.
- The `sops-age` Secret is missing.
- Encrypted manifests stop reconciling.
- An Age recipient must be rotated.
- A cluster is being rebuilt.

## Initial checks

Run:

    kubectl get secret sops-age --namespace flux-system

    kubectl get kustomization encrypted-secrets `
      --namespace flux-system

    kubectl describe kustomization encrypted-secrets `
      --namespace flux-system

    flux get kustomizations

## Restore the Age key

Run from a trusted workstation containing the backed-up private key:

    pwsh -File ./scripts/bootstrap-sops-age.ps1 `
      -KeyPath "$HOME\.config\sops\age\keys.txt"

## Force reconciliation

Run:

    flux reconcile source git k8s-platform-foundation `
      --namespace flux-system

    flux reconcile kustomization encrypted-secrets `
      --namespace flux-system `
      --with-source

## Validate recovery

Run:

    kubectl get secrets --namespace platform-secrets

    kubectl get kustomization encrypted-secrets `
      --namespace flux-system

    flux get kustomizations

    make sops-validate

## Rotation safety requirements

Do not remove access to the old private key until:

- all encrypted manifests contain the new recipient;
- Flux successfully decrypts every manifest;
- the new private key has a secure offline backup;
- recovery using the new private key has been tested;
- dependent workloads are healthy.

## Evidence to capture

- Flux reconciliation output
- Kustomization status and conditions
- Encrypted Secret validation output
- Key rotation timestamp
- Workload recovery status
- Location of the offline backup
