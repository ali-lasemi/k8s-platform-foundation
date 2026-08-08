# On-Call Handover Checklist

## Active incidents

Record:

- incident severity;
- start time;
- affected services;
- current impact;
- mitigation already applied;
- next investigation step;
- incident owner.

## Platform health

Confirm:

    kubectl get nodes

    kubectl get pods --all-namespaces

    flux get all --all-namespaces

Review:

- active critical alerts;
- failed Flux resources;
- degraded nodes;
- failed backups;
- certificate warnings;
- unresolved security events.

## Recent changes

Review:

    git log --oneline -10

Record recent:

- platform upgrades;
- application promotions;
- policy changes;
- secret rotations;
- dependency updates.

## Scheduled work

Record upcoming:

- maintenance;
- certificate changes;
- upgrades;
- disaster recovery tests;
- production promotions.

## Known risks

Document temporary conditions such as:

- reduced cluster capacity;
- disabled monitoring;
- delayed backup jobs;
- suspended Flux resources;
- temporary DNS changes.

## Handover completion

The incoming responder should understand:

- current platform state;
- active incidents;
- unresolved alerts;
- recent risky changes;
- immediate next actions.
