# Security Policy

## Supported versions

Security fixes are applied to the latest state of the `main` branch.

| Version | Supported |
|---------|-----------|
| `main`  | Yes       |
| Older commits and tags | No |

## Reporting a vulnerability

Do not report suspected vulnerabilities through public GitHub issues.

Use GitHub private vulnerability reporting when available. Include:

- affected files or components
- reproduction steps
- expected and actual behavior
- potential impact
- suggested mitigation, when known

Do not include real credentials, access tokens, private keys or sensitive
infrastructure information in the report.

## Response process

A valid report will be:

1. acknowledged
2. assessed for severity and impact
3. reproduced where possible
4. remediated and validated
5. disclosed after a fix is available

## Security scope

Relevant security issues include:

- credential or secret exposure
- privilege escalation
- unsafe Kubernetes RBAC
- container security weaknesses
- insecure default configuration
- supply-chain compromise
- command injection in automation scripts
- unauthorized cluster access
- unsafe backup or restore behavior

## Security expectations

Users are responsible for:

- protecting kubeconfig files
- rotating exposed credentials
- restricting administrative access
- reviewing network-specific configuration
- validating changes in a non-production environment
- maintaining supported component versions