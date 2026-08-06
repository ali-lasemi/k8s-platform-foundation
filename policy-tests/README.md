# Kubernetes Policy Tests

This directory contains positive and negative Kyverno policy tests for the
platform security baseline.

## Structure

- `fixtures/compliant` contains resources expected to pass.
- `fixtures/noncompliant` contains resources expected to fail.
- `kyverno-test.yaml` defines policies, resources and expected results.

## Run tests

    kyverno test policy-tests

## Test requirements

Every enforced policy should include:

- at least one compliant resource;
- at least one noncompliant resource;
- an explicit policy name;
- an explicit rule name;
- an explicit expected result.

## Maintenance

When a policy changes:

1. Update the related fixture.
2. Update the expected result.
3. Run the complete policy test suite.
4. Confirm unrelated policy tests still pass.
