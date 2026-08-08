$ErrorActionPreference = "Stop"

function Run-Step {
    param(
        [string]$Name,
        [scriptblock]$Command
    )

    Write-Host ""
    Write-Host "==> $Name"

    & $Command

    if (-not $?) {
        Write-Error "[FAIL] $Name"
        exit 1
    }

    Write-Host "[PASS] $Name"
}

Run-Step "Production readiness" {
    ./validation/production-readiness.ps1
}

Run-Step "Release gates" {
    ./validation/release-gates.ps1
}

Run-Step "Release version" {
    ./validation/release-version.ps1
}

Run-Step "Release checklist" {
    ./validation/release-checklist.ps1
}

Run-Step "Architecture documentation" {
    ./validation/architecture-docs.ps1
}

Run-Step "Production runbooks" {
    ./validation/runbooks.ps1
}

Run-Step "Environment promotion" {
    ./validation/environment-promotion.ps1
}

Run-Step "Policy test structure" {
    ./validation/policy-tests.ps1
}

Run-Step "SOPS foundation" {
    ./validation/sops-foundation.ps1
}

Run-Step "Encrypted Secrets" {
    ./validation/encrypted-secrets.ps1
}

Write-Host ""
Write-Host "=========================================="
Write-Host " v1.0 end-to-end release validation passed"
Write-Host "=========================================="
