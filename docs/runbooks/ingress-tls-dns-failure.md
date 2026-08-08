# Ingress, TLS and DNS Failure Runbook

## Symptoms

Use this runbook when:

- public endpoints are unreachable;
- HTTP requests return unexpected errors;
- certificates fail to issue or renew;
- DNS records are missing or incorrect;
- ExternalDNS cannot reconcile records;
- Traefik routes traffic incorrectly.

## Check ingress

    kubectl get ingress --all-namespaces

    kubectl describe ingress \
      --all-namespaces

Check Traefik:

    kubectl get pods \
      --namespace traefik-system

    kubectl logs deployment/traefik \
      --namespace traefik-system \
      --tail=200

## Check TLS

    kubectl get certificate \
      --all-namespaces

    kubectl get certificaterequest \
      --all-namespaces

    kubectl get challenge \
      --all-namespaces

    kubectl get order \
      --all-namespaces

Inspect the affected certificate:

    kubectl describe certificate CERTIFICATE_NAME \
      --namespace NAMESPACE

Check issuers:

    kubectl describe clusterissuer letsencrypt-staging

    kubectl describe clusterissuer letsencrypt-production

Use the staging issuer while troubleshooting repeated ACME failures.

## Check ExternalDNS

    kubectl get pods \
      --namespace external-dns

    kubectl logs deployment/external-dns \
      --namespace external-dns \
      --tail=200

Confirm the credential Secret exists:

    kubectl get secret cloudflare-api-token \
      --namespace external-dns

## GitOps reconciliation

    flux get kustomizations \
      --all-namespaces

If encrypted credentials failed to reconcile:

    flux reconcile kustomization encrypted-secrets \
      --namespace flux-system \
      --with-source

Then reconcile ExternalDNS:

    flux reconcile kustomization external-dns \
      --namespace flux-system \
      --with-source

## DNS safety

ExternalDNS should remain configured with `upsert-only` during incident
response.

Do not change it to `sync` as a troubleshooting shortcut.

Do not manually delete DNS records until TXT ownership records have been
reviewed.

## Recovery criteria

Recovery is complete when:

- DNS resolves to the expected address;
- Traefik accepts traffic;
- HTTP redirects to HTTPS;
- the expected certificate is Ready;
- ExternalDNS reconciliation succeeds;
- application endpoints return successful responses.
