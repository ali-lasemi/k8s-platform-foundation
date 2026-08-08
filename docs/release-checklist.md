# v1.0 Release Checklist

## Repository

- [ ] Working tree is clean.
- [ ] Local main matches origin/main.
- [ ] VERSION contains 1.0.0.
- [ ] CHANGELOG contains the 1.0.0 release.
- [ ] README represents the implemented platform accurately.
- [ ] Known limitations are documented.

## CI

- [ ] YAML lint passes.
- [ ] ShellCheck passes.
- [ ] shfmt passes.
- [ ] actionlint passes.
- [ ] Markdown lint passes.
- [ ] kubeconform passes.
- [ ] kube-linter passes.
- [ ] Trivy passes.
- [ ] Gitleaks passes.
- [ ] Kyverno regression tests pass.
- [ ] Integration tests pass.
- [ ] Production readiness passes.
- [ ] Release gates pass.

## Platform

- [ ] Core Kustomize trees render successfully.
- [ ] Development overlay renders successfully.
- [ ] Staging overlay renders successfully.
- [ ] Production overlay renders successfully.
- [ ] Flux dependency chain is valid.
- [ ] Production safeguards remain enabled.

## Security

- [ ] Policy test suite passes.
- [ ] SOPS configuration is valid.
- [ ] No private Age key exists in Git.
- [ ] Secret scanning passes.
- [ ] Security scanning passes.

## Documentation

- [ ] Architecture index is complete.
- [ ] Runbook index is complete.
- [ ] Capabilities matrix is complete.
- [ ] Release process is documented.
- [ ] Production readiness criteria are documented.

## Release

- [ ] Final v1.0 release preparation commit is pushed.
- [ ] All required GitHub Actions checks are green.
- [ ] Annotated v1.0.0 tag is created.
- [ ] Tag is pushed to origin.
- [ ] GitHub Release workflow succeeds.
- [ ] GitHub Release v1.0.0 exists.
- [ ] Release epic is closed.
