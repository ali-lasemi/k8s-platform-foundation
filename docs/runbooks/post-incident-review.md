# Post-Incident Review Template

## Incident summary

**Incident ID:**

**Severity:**

**Start time:**

**Recovery time:**

**Duration:**

**Affected services:**

## Executive summary

Describe what happened, the user or platform impact and how service was
restored.

## Impact

Document:

- affected workloads;
- affected environments;
- availability impact;
- data impact;
- security impact;
- operational impact.

## Timeline

| Time | Event |
| --- | --- |
| | Detection |
| | First response |
| | Mitigation |
| | Recovery |
| | Incident closed |

## Detection

Explain how the incident was discovered.

Was the detection:

- automated;
- alert-based;
- user-reported;
- manually discovered?

## Root cause

Describe the technical root cause.

Avoid assigning individual blame.

## Contributing factors

Document conditions that increased impact or recovery time.

## Resolution

Describe the mitigation and final recovery procedure.

## What worked well

Record effective:

- alerts;
- automation;
- runbooks;
- communication;
- recovery tooling.

## What did not work well

Record:

- missing telemetry;
- unclear procedures;
- failed automation;
- delayed decisions;
- unexpected dependencies.

## Action items

| Action | Priority | Owner | Status |
| --- | --- | --- | --- |
| | | | |

## Prevention

Document changes that reduce the probability or impact of recurrence.

## Evidence

Link or reference:

- relevant Git commits;
- logs;
- alerts;
- Kubernetes events;
- Flux status;
- recovery validation output.
