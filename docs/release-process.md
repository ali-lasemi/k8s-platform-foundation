# Release Process

## Versioning

The project follows Semantic Versioning:

    MAJOR.MINOR.PATCH

Examples:

- `1.0.0` for the first stable production release;
- `1.1.0` for backward-compatible platform capabilities;
- `1.0.1` for backward-compatible fixes;
- `2.0.0` for incompatible platform changes.

The canonical version is stored in:

    VERSION

Git release tags use the `v` prefix.

Example:

    v1.0.0

## Pre-release requirements

Before creating a stable release:

1. Confirm the working tree is clean.
2. Pull the latest `main`.
3. Confirm every required GitHub Actions check is green.
4. Run production readiness validation.
5. Run release-gate validation.
6. Review `CHANGELOG.md`.
7. Confirm `VERSION` matches the intended release.
8. Confirm known limitations are current.
9. Confirm architecture and operational documentation are current.

## Local validation

Run:

    pwsh -File ./validation/production-readiness.ps1

    pwsh -File ./validation/release-gates.ps1

## Create the release tag

For version `1.0.0`:

    git tag -a v1.0.0 -m "v1.0.0"

Verify:

    git show v1.0.0

Push:

    git push origin v1.0.0

Pushing the version tag triggers the GitHub release workflow.

## GitHub Release

The release workflow verifies:

- tag format;
- VERSION consistency;
- CHANGELOG presence;
- release documentation;
- production readiness inventory.

After validation, GitHub CLI creates the GitHub Release and generates release
notes from repository history.

## Release rollback

A published Git tag should not be silently moved.

If a released version contains a defect:

1. fix or revert the defect on `main`;
2. increment the patch version;
3. update the changelog;
4. create a new release tag.

Example:

    1.0.0 -> 1.0.1

Do not rewrite an already published stable release.
