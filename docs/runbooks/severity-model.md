# Incident Severity Model

## SEV-1 — Critical

Complete platform outage, major security incident or widespread loss of service.

Examples:

- Kubernetes control plane unavailable;
- production ingress unavailable;
- widespread data loss risk;
- compromised platform credentials;
- unrecoverable GitOps reconciliation failure.

Response expectations:

- immediate response;
- incident commander assigned;
- continuous investigation until stabilization;
- frequent stakeholder communication.

## SEV-2 — High

Major degradation affecting production reliability but without complete
platform failure.

Examples:

- partial production outage;
- one or more critical platform components unavailable;
- repeated failed deployments;
- certificate or DNS failures affecting important services;
- backup system unavailable.

Response expectations:

- rapid response;
- coordinated technical investigation;
- stakeholder communication as needed.

## SEV-3 — Medium

Limited service impact with available workarounds.

Examples:

- single workload degradation;
- non-critical monitoring gaps;
- one unhealthy worker node with remaining capacity;
- delayed GitOps reconciliation.

Response expectations:

- investigate during normal operational response;
- document remediation.

## SEV-4 — Low

No active production impact.

Examples:

- warnings;
- documentation defects;
- non-blocking platform drift;
- maintenance issues.

Response expectations:

- track through normal engineering workflow.
