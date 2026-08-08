$ErrorActionPreference = "Stop"

$environments = @(
    "dev",
    "staging",
    "production"
)

foreach ($environment in $environments) {
    $path = "environments\$environment"

    kubectl kustomize $path *> $null

    if ($LASTEXITCODE -ne 0) {
        Write-Error "Environment failed to render: $environment"
        exit 1
    }
}

$production = Get-Content `
    "environments\production\kustomization.yaml" `
    -Raw

if ($production -notmatch "value:\s+3") {
    Write-Error "Production replica policy is missing."
    exit 1
}

if (-not (Test-Path "environments\production\pdb.yaml")) {
    Write-Error "Production PodDisruptionBudget is missing."
    exit 1
}

Write-Host "[INFO] Multi-environment validation passed."
