# Security

## Security architecture

The platform uses layered controls:

1. Pod Security Admission provides Kubernetes-native namespace enforcement.
2. Kyverno provides admission policy, governance and background reporting.
3. NetworkPolicy limits workload communication.
4. ResourceQuota and LimitRange prevent uncontrolled resource consumption.
5. CI scans policies and Kubernetes manifests before deployment.

## Protected namespaces

Namespaces labeled with the following value receive the enforced Kyverno
baseline:

```yaml
security.platform.io/enforce: restricted
```

The `platform-system` namespace enables this label by default.

## Enforced controls

Protected workloads must:

- run as non-root
- use an approved seccomp profile
- drop all Linux capabilities
- use a read-only root filesystem
- declare CPU and memory requests and limits
- disable automatic service-account token mounting
- avoid privileged mode
- avoid host namespaces
- avoid hostPath volumes
- use explicitly tagged container images

Standard application labels are initially enforced in audit mode.

## Validation

Run the live-cluster security test:

```bash
make security-validate
```

The validation creates a temporary protected namespace and verifies that unsafe
workloads are rejected by the Kubernetes admission path.

## Policy rollout

New restrictive policies should follow this sequence:

1. deploy with `validationFailureAction: Audit`
2. review PolicyReports and affected workloads
3. remediate existing violations
4. switch the policy to `Enforce`
5. run security and integration validation

## Exceptions

Policy exceptions must:

- be narrowly scoped
- include a documented operational reason
- have an owner
- include an expiration or review date
- never be used to bypass unresolved platform defects

## Secrets

Plaintext production credentials, kubeconfigs, private keys and Age private
keys must never be committed.

Encrypted GitOps secret management will be implemented with SOPS and Age in a
dedicated security phase.
