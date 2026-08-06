$ErrorActionPreference = "Stop"

$requiredFiles = @(
    ".sops.yaml",
    "gitops\flux-system\secrets.yaml",
    "secrets\kustomization.yaml",
    "scripts\generate-age-key.ps1",
    "scripts\bootstrap-sops-age.ps1",
    "scripts\update-sops-age-recipient.ps1",
    "scripts\encrypt-secret.ps1",
    "scripts\decrypt-secret.ps1"
)

foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file)) {
        Write-Error "Required file is missing: $file"
        exit 1
    }
}

$sopsConfig = Get-Content ".sops.yaml" -Raw

if ($sopsConfig -notmatch "encrypted_regex:\s+\^\(data\|stringData\)\$") {
    Write-Error "SOPS encrypted field selection is invalid."
    exit 1
}

if ($sopsConfig -notmatch "path_regex:") {
    Write-Error "SOPS path rules are missing."
    exit 1
}

$fluxConfig = Get-Content "gitops\flux-system\secrets.yaml" -Raw

if ($fluxConfig -notmatch "provider:\s+sops") {
    Write-Error "Flux SOPS decryption provider is missing."
    exit 1
}

if ($fluxConfig -notmatch "name:\s+sops-age") {
    Write-Error "Flux SOPS Age secret reference is missing."
    exit 1
}

$plaintextCandidates = Get-ChildItem `
    "secrets" `
    -Recurse `
    -File `
    -Include "*.yaml", "*.yml" |
    Where-Object {
        $_.Name -notlike "*.template.yaml" -and
        $_.Name -notlike "*.enc.yaml" -and
        $_.Name -ne "kustomization.yaml" -and
        $_.Name -ne "namespace.yaml"
    }

if ($plaintextCandidates.Count -gt 0) {
    $paths = $plaintextCandidates.FullName -join "`n"

    Write-Error "Unexpected plaintext secret files found:`n$paths"
    exit 1
}

Write-Host "[INFO] SOPS and Flux foundation validation passed."
