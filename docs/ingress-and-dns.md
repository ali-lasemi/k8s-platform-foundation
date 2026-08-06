# Production Ingress and DNS Automation

## Components

- Traefik for north-south traffic
- cert-manager for automated TLS certificates
- Let's Encrypt staging and production issuers
- ExternalDNS for Cloudflare DNS records
- SOPS and Age for Cloudflare API token encryption
- Hardened middleware for redirects, headers and rate limiting

## Required configuration

Replace these placeholders before deployment:

- `platform-admin@example.com`
- `platform.example.com`
- `demo.platform.example.com`

## Cloudflare token

Create a restricted Cloudflare API token with permission to manage DNS records
for only the required zone.

Copy the template:

    secrets/external-dns/cloudflare-api-token.template.yaml

Encrypt it with SOPS and add the encrypted manifest to the appropriate
Kustomization.

The resulting Secret must be named:

    cloudflare-api-token

The required key is:

    apiToken

## Certificate issuers

Use the staging issuer first:

    letsencrypt-staging

After successful validation, switch public workloads to:

    letsencrypt-production

## ExternalDNS safety

ExternalDNS uses `upsert-only`. This allows record creation and updates but
prevents automatic deletion of existing DNS records.

The TXT registry tracks ownership with:

    k8s-platform-foundation

## Validation

Static validation:

    pwsh -File ./validation/ingress-dns-static.ps1

Live-cluster validation:

    ./validation/ingress-dns-health.sh

## Production checklist

- Replace placeholder domain names.
- Replace the placeholder ACME email.
- Encrypt the Cloudflare API token.
- Reconcile encrypted Secrets before ExternalDNS.
- Test certificate issuance with Let's Encrypt staging.
- Confirm DNS ownership TXT records.
- Confirm HTTP redirects to HTTPS.
- Confirm security headers.
- Confirm rate limiting.
- Switch the workload to the production issuer.
