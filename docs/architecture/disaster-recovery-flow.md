# Backup and Disaster Recovery Flow

```mermaid
flowchart TB
    Cluster[Kubernetes Cluster]

    Etcd[k3s etcd]
    Snapshot[etcd Snapshot]
    Checksum[SHA-256 Verification]

    Velero[Velero]
    Resources[Kubernetes Resources]
    Volumes[Persistent Data]
    Storage[Backup Object Storage]

    RecoveryHost[Replacement Control Plane]
    Flux[Flux GitOps]
    Git[Git Repository]

    Cluster --> Etcd
    Etcd --> Snapshot
    Snapshot --> Checksum

    Cluster --> Resources
    Cluster --> Volumes

    Resources --> Velero
    Volumes --> Velero
    Velero --> Storage

    Snapshot --> RecoveryHost
    Storage --> RecoveryHost

    Git --> Flux
    Flux --> RecoveryHost

    RecoveryHost -->|Rebuild desired state| Cluster
```

## Recovery layers

The recovery architecture protects the platform at multiple levels:

- k3s etcd snapshots protect control-plane state;
- checksums validate snapshot integrity;
- Velero protects Kubernetes resources and persistent data;
- Git stores declarative desired state;
- Flux reconstructs platform components after cluster recovery.

Recovery procedures validate both restored state and subsequent GitOps
reconciliation.
