# Kubernetes Policy Testing

## Overview

The repository includes automated Kyverno policy regression testing with:

- compliant fixtures;
- noncompliant fixtures;
- explicit pass and fail expectations;
- CI regression tests;
- live-cluster admission validation;
- coverage checks for the enforced security baseline.

## Test layers

### Static coverage validation

The PowerShell validation script confirms that required policy files, fixtures
and expected results exist.

Run:

    make policy-test-validate

### Kyverno CLI regression tests

The Kyverno CLI evaluates policy behavior without requiring a live cluster.

Run:

    make policy-test

### Live admission testing

The live-cluster test verifies that the Kyverno admission controller accepts
compliant resources and rejects unsafe resources.

Run:

    make policy-admission-test

## Coverage matrix

| Policy | Compliant test | Noncompliant test |
| --- | --- | --- |
| disallow-privileged | compliant-pod | privileged-pod |
| disallow-host-path | compliant-pod | host-path-pod |
| disallow-host-namespaces | compliant-pod | host-namespace-pod |
| disallow-latest-tag | compliant-pod | latest-tag-pod |
| require-resources | compliant-pod | missing-resources-pod |
| require-read-only-root-filesystem | compliant-pod | writable-root-pod |
| disable-service-account-token | compliant-pod | service-account-token-pod |
| require-non-root | compliant-pod | policy regression suite |
| require-seccomp | compliant-pod | policy regression suite |
| drop-capabilities | compliant-pod | policy regression suite |
| require-standard-labels | compliant-pod | policy regression suite |

## Policy change workflow

When changing a policy:

1. Keep the policy and rule names stable when possible.
2. Add or update compliant fixtures.
3. Add or update noncompliant fixtures.
4. Update expected results in `policy-tests/kyverno-test.yaml`.
5. Run static coverage validation.
6. Run Kyverno CLI tests.
7. Run live admission testing.
8. Confirm unrelated policy tests still pass.

## Failure investigation

For Kyverno CLI failures:

    kyverno test policy-tests --detailed-results

For live admission failures:

    kubectl get pods --namespace kyverno

    kubectl logs deployment/kyverno-admission-controller \
      --namespace kyverno

    kubectl get clusterpolicies

    kubectl describe clusterpolicy POLICY_NAME

## Safety

Live admission tests use an isolated temporary namespace and delete it after
completion.

Do not run negative fixtures against production namespaces.
