# Initial Incident Triage

## Step 1 — Confirm cluster access

    kubectl cluster-info

    kubectl get nodes -o wide

If the Kubernetes API is unavailable, move immediately to the control-plane
failure runbook.

## Step 2 — Check node health

    kubectl get nodes

Look for:

- NotReady nodes;
- scheduling disabled;
- memory pressure;
- disk pressure;
- PID pressure;
- network unavailable.

## Step 3 — Check workload health

    kubectl get pods --all-namespaces

Look for:

- CrashLoopBackOff;
- ImagePullBackOff;
- Pending;
- Error;
- excessive restarts.

## Step 4 — Check recent events

    kubectl get events --all-namespaces \
      --sort-by=.lastTimestamp

Focus on recent:

- scheduling failures;
- image failures;
- admission denials;
- storage failures;
- health probe failures.

## Step 5 — Check GitOps

    flux get sources git --all-namespaces

    flux get kustomizations --all-namespaces

    flux get helmreleases --all-namespaces

Identify:

- failed reconciliation;
- dependency failures;
- stalled Helm releases;
- source fetch errors.

## Step 6 — Check recent changes

    git log --oneline -10

Review recent:

- promotions;
- dependency updates;
- policy changes;
- platform component upgrades.

## Step 7 — Preserve evidence

Capture relevant output before destructive mitigation.

Recommended evidence:

    kubectl get nodes -o yaml

    kubectl get pods --all-namespaces -o wide

    kubectl get events --all-namespaces \
      --sort-by=.lastTimestamp

    flux get all --all-namespaces

Use the repository cluster-state export tooling when available.
