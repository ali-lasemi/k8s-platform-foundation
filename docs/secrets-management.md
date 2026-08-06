# Encrypted GitOps Secrets Management

## Overview

The platform uses SOPS with Age to encrypt Kubernetes Secret values before
manifests are committed to Git.

Flux decrypts encrypted manifests during reconciliation by using the Age
private key stored in the `sops-age` Secret in the `flux-system` namespace.

## Security model

- Age private keys never enter Git.
- Only `data` and `stringData` fields are encrypted.
- Encrypted manifests use the `.enc.yaml` suffix.
- Plaintext templates contain placeholder values only.
- CI validates encrypted manifests.
- Gitleaks scans the repository for exposed credentials.
- Flux performs decryption inside the cluster.

## Generate an Age key

Run:

    make sops-generate-key

The private key is created at:

    $HOME\.config\sops\age\keys.txt

Store a backup of this file in a secure offline location.

## Configure the Age recipient

Run:

    make sops-update-recipient

This replaces `AGE_PUBLIC_KEY_REPLACE_ME` in `.sops.yaml` with the generated
Age public key.

## Bootstrap Flux decryption

Run:

    make sops-bootstrap

This creates or updates the `sops-age` Secret in the `flux-system` namespace.

## Encrypt a Secret

Run:

    pwsh -File ./scripts/encrypt-secret.ps1 `
      -InputFile ./secrets/examples/example-secret.template.yaml

The generated encrypted manifest uses the `.enc.yaml` suffix.

## Decrypt a Secret locally

Run:

    pwsh -File ./scripts/decrypt-secret.ps1 `
      -InputFile ./secrets/examples/example-secret.enc.yaml

Decrypted files are excluded by `.gitignore` and must be deleted after use.

## Rotate the Age recipient

Generate and securely back up a new Age key.

Then run:

    pwsh -File ./scripts/rotate-sops-age-key.ps1 `
      -NewRecipient age1REPLACE_WITH_NEW_PUBLIC_KEY

Bootstrap the new private key into Flux before removing access to the old key.

## Recovery

If the cluster loses the `sops-age` Secret:

1. Retrieve the backed-up Age private key.
2. Recreate the Secret with `make sops-bootstrap`.
3. Reconcile the Flux source.
4. Reconcile the encrypted secrets Kustomization.
5. Validate that workloads can read their Secrets.

If every copy of the private key is permanently lost, encrypted values cannot
be recovered.

## Validation

Run:

    make sops-validate
