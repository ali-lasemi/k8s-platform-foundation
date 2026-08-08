# Known Limitations

This repository is a production-oriented reference platform, not a managed
Kubernetes distribution.

## Infrastructure provisioning

The repository assumes Linux hosts already exist.

It does not provision:

- virtual machines;
- cloud networking;
- DNS zones;
- firewalls outside Kubernetes;
- object storage infrastructure.

These concerns would typically be managed through Terraform or another
infrastructure-as-code layer.

## Cloud provider scope

ExternalDNS examples target Cloudflare.

Other DNS providers require provider-specific configuration.

## Storage

The repository does not provide a distributed block-storage platform such as:

- Longhorn;
- Rook Ceph;
- OpenEBS.

Persistent storage architecture must be selected according to workload and
infrastructure requirements.

## High availability

The foundation supports multi-node patterns, but a fully validated multi-server
k3s HA topology is environment-dependent.

Production operators must design:

- server quorum;
- load balancing;
- failure domains;
- host-level redundancy.

## Secrets bootstrap

The initial Age private key must be injected into the cluster through a trusted
out-of-band bootstrap procedure.

This is intentional because committing the private key to Git would break the
security model.

## External dependencies

The platform depends on external projects and services including:

- GitHub;
- Flux;
- Let's Encrypt;
- Cloudflare;
- container registries;
- Helm repositories.

Outages affecting these dependencies may delay reconciliation or deployment.

## Validation scope

CI validates repository structure, policy behavior, rendering and integration
scenarios.

CI does not prove that every infrastructure topology, DNS provider or storage
backend will behave identically in production.

## Operational responsibility

Production use still requires:

- capacity planning;
- SLO definition;
- change management;
- vulnerability management;
- key backup procedures;
- disaster recovery exercises;
- regular upgrade testing.
