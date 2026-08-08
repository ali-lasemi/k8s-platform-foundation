# Incident Response Runbook

## Purpose

This runbook defines the standard response process for incidents affecting the
Kubernetes platform.

The objectives are:

- protect service availability;
- limit customer and platform impact;
- restore healthy service safely;
- preserve evidence;
- communicate clearly;
- document follow-up actions.

## Incident lifecycle

1. Detect
2. Triage
3. Classify severity
4. Stabilize
5. Investigate
6. Recover
7. Validate
8. Communicate
9. Review

## Incident roles

### Incident commander

Coordinates the response and owns incident-level decisions.

Responsibilities:

- establish severity;
- coordinate responders;
- track decisions;
- manage communication;
- declare recovery.

### Technical responder

Investigates and mitigates the technical failure.

Responsibilities:

- collect platform evidence;
- execute runbooks;
- propose mitigation;
- validate recovery.

### Communications owner

Maintains stakeholder updates during significant incidents.

## Initial response

Do not immediately restart or delete resources without understanding the
failure mode.

Start with:

    kubectl get nodes

    kubectl get pods --all-namespaces

    kubectl get events --all-namespaces \
      --sort-by=.lastTimestamp

    flux get all --all-namespaces

Record:

- incident start time;
- affected services;
- recent deployments;
- recent Git changes;
- failing nodes or workloads;
- active alerts.

## Stabilization principles

Prefer reversible actions.

Examples:

- revert a Git promotion;
- suspend a failing Flux reconciliation;
- cordon a problematic node;
- scale healthy replicas;
- restore a known-good configuration.

Avoid destructive actions until recovery data and evidence have been captured.

## Recovery validation

After mitigation:

    kubectl get nodes

    kubectl get pods --all-namespaces

    flux get all --all-namespaces

Run platform-specific validation commands documented in the relevant runbook.

## Incident closure

An incident can be closed when:

- service is stable;
- critical alerts are resolved;
- Flux reconciliation is healthy;
- affected workloads are healthy;
- recovery has been validated;
- follow-up actions have been recorded.
