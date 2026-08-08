$ErrorActionPreference = "Stop"

$requiredFiles = @(
    "platform\traefik\middlewares\https-redirect.yaml",
    "platform\traefik\middlewares\security-headers.yaml",
    "platform\traefik\middlewares\rate-limit.yaml",
    "platform\traefik\middlewares\tls-options.yaml",
    "platform\cert-manager\issuers\letsencrypt-staging.yaml",
    "platform\cert-manager\issuers\letsencrypt-production.yaml",
    "platform\external-dns\release.yaml",
    "gitops\flux-system\external-dns.yaml",
    "examples\ingress-demo\ingress.yaml",
    "examples\ingress-demo\http-redirect.yaml"
)

foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file)) {
        Write-Error "Required file is missing: $file"
        exit 1
    }
}

$externalDns = Get-Content "platform\external-dns\release.yaml" -Raw

if ($externalDns -notmatch "provider:\s*\r?\n\s+name:\s*cloudflare") {
    Write-Error "ExternalDNS Cloudflare provider is not configured."
    exit 1
}

if ($externalDns -notmatch "policy:\s+upsert-only") {
    Write-Error "ExternalDNS must use the safe upsert-only policy."
    exit 1
}

if ($externalDns -notmatch "name:\s+cloudflare-api-token") {
    Write-Error "ExternalDNS Cloudflare Secret reference is missing."
    exit 1
}

$productionIssuer = Get-Content `
    "platform\cert-manager\issuers\letsencrypt-production.yaml" `
    -Raw

if (
    $productionIssuer -notmatch
    "https://acme-v02\.api\.letsencrypt\.org/directory"
) {
    Write-Error "Let's Encrypt production endpoint is invalid."
    exit 1
}

$stagingIssuer = Get-Content `
    "platform\cert-manager\issuers\letsencrypt-staging.yaml" `
    -Raw

if (
    $stagingIssuer -notmatch
    "https://acme-staging-v02\.api\.letsencrypt\.org/directory"
) {
    Write-Error "Let's Encrypt staging endpoint is invalid."
    exit 1
}

$ingress = Get-Content "examples\ingress-demo\ingress.yaml" -Raw

if ($ingress -notmatch "cert-manager.io/cluster-issuer") {
    Write-Error "Ingress cert-manager issuer annotation is missing."
    exit 1
}

if ($ingress -notmatch "external-dns.alpha.kubernetes.io/hostname") {
    Write-Error "Ingress ExternalDNS hostname annotation is missing."
    exit 1
}

if ($ingress -notmatch "router.entrypoints:\s+websecure") {
    Write-Error "Ingress is not restricted to the websecure entrypoint."
    exit 1
}

Write-Host "[INFO] Ingress and DNS static validation passed."
