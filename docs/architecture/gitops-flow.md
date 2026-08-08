# GitOps Reconciliation Flow

```mermaid
sequenceDiagram
    autonumber

    participant Engineer as Platform Engineer
    participant GitHub as GitHub Repository
    participant Source as Flux Source Controller
    participant Kustomize as Flux Kustomize Controller
    participant Helm as Flux Helm Controller
    participant API as Kubernetes API

    Engineer->>GitHub: Commit desired state

    loop Reconciliation interval
        Source->>GitHub: Fetch repository revision
        GitHub-->>Source: Git artifact

        Source-->>Kustomize: New source artifact
        Kustomize->>API: Reconcile Kubernetes resources

        Kustomize->>API: Create or update HelmRelease
        Helm->>API: Install or upgrade Helm workloads

        API-->>Kustomize: Resource readiness
        API-->>Helm: Release status
    end

    Kustomize-->>Engineer: Reconciliation status via Flux
```

## Reconciliation model

Flux continuously compares the desired state stored in Git with the state of
the Kubernetes cluster.

Normal platform changes are made through Git rather than direct manual
application of manifests.

Manual cluster operations are limited to:

- initial bootstrap;
- disaster recovery;
- emergency diagnostics;
- documented lifecycle operations;
- controlled secret bootstrap.
