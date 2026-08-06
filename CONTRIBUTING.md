# Contributing

Thank you for contributing to `k8s-platform-foundation`.

This repository follows an issue-driven development workflow. Every meaningful
change must be associated with a GitHub issue.

## Development workflow

1. Create or select an existing issue.
2. Confirm the issue scope and acceptance criteria.
3. Implement the smallest complete production-ready change.
4. Add or update validation.
5. Update relevant documentation.
6. Run all local quality checks.
7. Commit using Conventional Commits.
8. Reference the issue in the pull request or commit.
9. Merge only after all required checks pass.

## Engineering requirements

All contributions must:

- avoid committing credentials or private keys
- use pinned versions where practical
- remain reproducible and idempotent
- include explicit error handling
- include validation for operational changes
- use UTF-8 encoding and LF line endings
- pass ShellCheck for shell scripts
- pass YAML and Kubernetes manifest validation
- document operational impact and rollback steps

## Commit convention

Use Conventional Commits:

```text
feat: add a platform capability
fix: correct broken behavior
docs: update documentation
ci: change continuous integration
test: add or improve validation
refactor: restructure without changing behavior
chore: perform repository maintenance
```

Use an issue reference when closing an issue:

```text
feat: establish repository governance

Closes #1
```

## Shell scripts

Shell scripts must:

- use `#!/usr/bin/env bash`
- enable `set -Eeuo pipefail`
- quote variable expansions
- validate required commands and environment variables
- avoid printing secrets
- be safe to run repeatedly where applicable

## Kubernetes manifests

Kubernetes manifests must:

- specify stable API versions
- include explicit namespaces
- define resource requests and limits where applicable
- use security contexts where supported
- avoid plaintext production secrets
- be valid under Kustomize and Kubernetes schema validation

## Documentation

Operational documentation must include:

- prerequisites
- execution steps
- validation steps
- rollback or recovery guidance
- security considerations where relevant

## Pull requests

Pull requests must remain focused. Unrelated changes should be submitted
separately.

All required CI checks must pass before merge.
