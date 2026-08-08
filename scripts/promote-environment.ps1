[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("dev-to-staging", "staging-to-production")]
    [string]$Promotion,

    [Parameter(Mandatory = $true)]
    [string]$Image
)

$ErrorActionPreference = "Stop"

function Fail {
    param([string]$Message)

    Write-Error $Message
    exit 1
}

if ($Image -match ":latest$") {
    Fail "Promotion with the latest tag is not allowed."
}

switch ($Promotion) {
    "dev-to-staging" {
        $Target = "environments\staging\kustomization.yaml"
    }

    "staging-to-production" {
        $Target = "environments\production\kustomization.yaml"
    }
}

if (-not (Test-Path $Target)) {
    Fail "Target environment was not found: $Target"
}

Push-Location (Split-Path $Target -Parent)

try {
    if (-not (Get-Command kubectl -ErrorAction SilentlyContinue)) {
        Fail "kubectl is required."
    }

    kubectl kustomize . *> $null

    if ($LASTEXITCODE -ne 0) {
        Fail "Target environment does not render successfully."
    }

    kustomize edit set image "traefik/whoami=$Image"

    if ($LASTEXITCODE -ne 0) {
        Fail "Failed to update environment image."
    }
}
finally {
    Pop-Location
}

Write-Host "[INFO] Promotion prepared: $Promotion"
Write-Host "[INFO] Image: $Image"
Write-Host "[INFO] Review and commit the resulting Git change."
