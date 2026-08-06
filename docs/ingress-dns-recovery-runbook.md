# Ingress and DNS Recovery Runbook

## Initial checks

    kubectl get pods --namespace traefik-system
    kubectl get pods --namespace cert-manager
    kubectl get pods --namespace external-dns
    kubectl get ingress --all-namespaces
    kubectl get certificate --all-namespaces
    kubectl get certificaterequest --all-namespaces
    kubectl get challenge --all-namespaces
    kubectl get order --all-namespaces

## ExternalDNS failure

    kubectl logs deployment/external-dns \
      --namespace external-dns

    kubectl get secret cloudflare-api-token \
      --namespace external-dns

    flux reconcile kustomization encrypted-secrets \
      --namespace flux-system \
      --with-source

    flux reconcile kustomization external-dns \
      --namespace flux-system \
      --with-source

## Certificate failure

    kubectl describe certificate ingress-demo-tls \
      --namespace ingress-demo

    kubectl describe clusterissuer letsencrypt-staging

    kubectl describe clusterissuer letsencrypt-production

Use the staging issuer while troubleshooting repeated ACME failures.

## Traefik failure

    kubectl logs deployment/traefik \
      --namespace traefik-system

    kubectl describe ingress ingress-demo \
      --namespace ingress-demo

    kubectl get middleware \
      --all-namespaces

    kubectl get tlsoption \
      --all-namespaces

## DNS safety

Do not delete Cloudflare records manually until ExternalDNS ownership TXT
records have been reviewed.

Do not change ExternalDNS from `upsert-only` to `sync` during incident
response.

## Recovery validation

    ./validation/ingress-dns-health.sh

    flux get kustomizations

    kubectl get certificate \
      --all-namespaces
