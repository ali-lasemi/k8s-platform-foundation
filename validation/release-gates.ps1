$ErrorActionPreference = "Stop"

function Fail {
    param([string]$Message)

    Write-Error "[FAIL] $Message"
    exit 1
}

function Pass {
    param([string]$Message)

    Write-Host "[PASS] $Message"
}

$requiredDocs = @(
    "docs\production-readiness.md",
    "docs\capabilities.md",
    "docs\limitations.md",
    "docs\roadmap.md",
    "docs\architecture\README.md",
    "docs\runbooks\README.md"
)

foreach ($file in $requiredDocs) {
    if (-not (Test-Path $file)) {
        Fail "Release documentation missing: $file"
    }
}

Pass "Release documentation inventory is complete."

$requiredValidation = @(
    "validation\production-readiness.ps1",
    "validation\policy-tests.ps1",
    "validation\architecture-docs.ps1",
    "validation\runbooks.ps1",
    "validation\environment-promotion.ps1"
)

foreach ($file in $requiredValidation) {
    if (-not (Test-Path $file)) {
        Fail "Release validation missing: $file"
    }
}

Pass "Release validation inventory is complete."

$requiredWorkflows = @(
    ".github\workflows\validate.yml",
    ".github\workflows\security.yml",
    ".github\workflows\integration.yml",
    ".github\workflows\policy-tests.yml",
    ".github\workflows\environment-promotion.yml",
    ".github\workflows\architecture-docs.yml",
    ".github\workflows\runbooks.yml",
    ".github\workflows\production-readiness.yml"
)

foreach ($file in $requiredWorkflows) {
    if (-not (Test-Path $file)) {
        Fail "Required CI workflow missing: $file"
    }
}

Pass "Required CI workflows are present."

$readme = Get-Content "README.md" -Raw

$requiredReadmeSections = @(
    "Architecture",
    "Operations"
)

foreach ($section in $requiredReadmeSections) {
    if ($readme -notmatch [regex]::Escape($section)) {
        Fail "README is missing required section: $section"
    }
}

Pass "README release sections are present."

$latestTags = Get-ChildItem `
    -Recurse `
    -File `
    -Include "*.yaml","*.yml" |
    Select-String `
        -Pattern 'image:\s+\S+:latest'

if ($latestTags) {
    Write-Host "[WARN] Found latest-tag image references:"
    $latestTags |
        ForEach-Object {
            Write-Host "       $($_.Path):$($_.LineNumber)"
        }
}

Write-Host ""
Write-Host "Release gate inventory validation passed."
