# Security

## Current controls

- Namespace-level Pod Security Admission labels
- Default-deny network policy for platform workloads
- Explicit DNS egress policy
- Non-root security contexts where supported
- Read-only root filesystem for Traefik
- Resource requests and limits
- GitOps reconciliation with pruning
- No credentials committed to the repository

## Secret policy

Plaintext production credentials must never be committed.

The secrets-management phase will introduce encrypted GitOps secrets using
SOPS and Age keys.

## Administrative access

Cluster-admin kubeconfig files must:

- use file mode `0600`
- remain outside the repository
- be rotated after suspected exposure
- be stored only on trusted administrative systems