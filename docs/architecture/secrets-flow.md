# Encrypted Secrets Flow

```mermaid
sequenceDiagram
    autonumber

    participant Engineer as Platform Engineer
    participant SOPS as SOPS + Age
    participant Git as Git Repository
    participant Flux as Flux Kustomize Controller
    participant Key as sops-age Secret
    participant API as Kubernetes API
    participant App as Workload

    Engineer->>SOPS: Encrypt Secret values
    SOPS-->>Engineer: Encrypted manifest

    Engineer->>Git: Commit encrypted manifest

    Flux->>Git: Fetch desired state
    Flux->>Key: Read Age private key
    Flux->>Flux: Decrypt SOPS manifest
    Flux->>API: Apply Kubernetes Secret

    API-->>App: Secret available to workload
```

## Security boundary

The Age private key is never committed to Git.

Git stores encrypted Secret manifests only.

Flux performs decryption during reconciliation using the private key stored in
the cluster.

Plaintext Secret values exist only where required for Kubernetes runtime use.
