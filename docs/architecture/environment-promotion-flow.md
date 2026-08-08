# Multi-Environment Promotion Flow

```mermaid
flowchart LR
    Engineer[Platform Engineer]

    DevGit[Development Desired State]
    Dev[Development]

    StageGit[Staging Desired State]
    Staging[Staging]

    ProdGit[Production Desired State]
    Production[Production]

    CI[CI Validation]
    Flux[Flux Reconciliation]

    Engineer --> DevGit
    DevGit --> CI
    CI --> Flux
    Flux --> Dev

    Dev -->|Validated version| StageGit
    StageGit --> CI
    CI --> Flux
    Flux --> Staging

    Staging -->|Approved version| ProdGit
    ProdGit --> CI
    CI --> Flux
    Flux --> Production

    Production -->|Failure| Engineer
    Engineer -->|Git revert| ProdGit
```

## Promotion model

Application versions move through environments using reviewed Git changes.

The intended sequence is:

    development -> staging -> production

Each target environment is rendered and validated before reconciliation.

Production includes additional resource and availability safeguards.

Rollback is performed through a Git revert followed by Flux reconciliation.
