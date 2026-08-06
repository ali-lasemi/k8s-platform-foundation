# Threat Model

## Protected assets

- Kubernetes API access
- cluster administrator credentials
- service-account tokens
- GitOps reconciliation authority
- container workloads
- persistent application data
- backup and recovery data
- software supply-chain integrity

## Trust boundaries

- operator workstation to Kubernetes API
- GitHub to Flux source-controller
- Kubernetes admission requests to Kyverno
- ingress traffic to platform workloads
- workload traffic across namespaces
- cluster nodes to control-plane services

## Primary threats

### Privileged workload execution

An attacker may attempt to create privileged containers, use host namespaces,
mount host paths or retain Linux capabilities.

Controls:

- Pod Security Admission
- Kyverno admission policies
- non-root execution
- seccomp profiles
- dropped capabilities
- read-only root filesystems

### Credential exposure

An attacker may obtain kubeconfig files, service-account tokens or plaintext
secrets.

Controls:

- disabled service-account token automount
- restrictive kubeconfig permissions
- no plaintext secrets in Git
- planned SOPS encryption
- credential rotation procedures

### Resource exhaustion

A compromised or defective workload may consume excessive CPU, memory, pods or
persistent volumes.

Controls:

- resource requests and limits
- namespace ResourceQuota
- namespace LimitRange
- observability and alerting

### Supply-chain compromise

A malicious or compromised image, chart or GitHub Action may enter the
platform.

Controls:

- pinned component versions
- explicit image tags
- Dependabot updates
- Trivy configuration scanning
- planned image verification and provenance controls

### Unauthorized network access

A workload may communicate with services it should not access.

Controls:

- default-deny NetworkPolicy
- explicit DNS egress
- namespace-scoped network rules
- ingress through managed entry points

## Residual risks

- a compromised cluster administrator remains highly privileged
- container images are not yet signature-verified
- encrypted GitOps secrets are not yet implemented
- backup integrity testing is not yet automated
- single-control-plane topology is not highly available
