# Architecture

## Overview

This repository provides a reproducible Kubernetes foundation for self-hosted
platforms using k3s.

## Initial topology

- One control-plane node
- Zero or more worker nodes
- Embedded Kubernetes datastore
- CoreDNS for internal DNS
- Local Path Provisioner for initial persistent storage

## Design principles

- Reproducible installation
- Pinned software versions
- Idempotent operations
- Explicit health validation
- No committed credentials
- Least-privilege security
- GitOps-ready configuration
- Documented recovery procedures
