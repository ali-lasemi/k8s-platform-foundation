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

$requiredFiles = @(
    "VERSION",
    "CHANGELOG.md",
    "README.md",
    "docs\release-process.md",
    "docs\release-checklist.md",
    "docs\capabilities.md",
    "docs\limitations.md",
    "docs\production-readiness.md",
    "docs\roadmap.md"
)

foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file)) {
        Fail "Missing release artifact: $file"
    }
}

Pass "Release artifact inventory is complete."

$version = (Get-Content "VERSION" -Raw).Trim()

if ($version -ne "1.0.0") {
    Fail "Expected VERSION 1.0.0 but found $version."
}

Pass "VERSION is 1.0.0."

$changelog = Get-Content "CHANGELOG.md" -Raw

if ($changelog -notmatch '\[1\.0\.0\]') {
    Fail "CHANGELOG does not contain the 1.0.0 release."
}

Pass "CHANGELOG contains the 1.0.0 release."

$readme = Get-Content "README.md" -Raw

$requiredSections = @(
    "Platform scope",
    "Architecture",
    "GitOps delivery model",
    "Security model",
    "Observability",
    "Backup and disaster recovery",
    "Progressive delivery",
    "Operations",
    "Validation",
    "Capabilities",
    "Known limitations",
    "Release",
    "Project status"
)

foreach ($section in $requiredSections) {
    if ($readme -notmatch [regex]::Escape("## $section")) {
        Fail "README section missing: $section"
    }
}

Pass "README release structure is complete."

$releaseProcess = Get-Content "docs\release-process.md" -Raw

if ($releaseProcess -notmatch "Semantic Versioning") {
    Fail "Release process does not document Semantic Versioning."
}

if ($releaseProcess -notmatch "v1\.0\.0") {
    Fail "Release process does not document the v1.0.0 tag."
}

Pass "Release process documentation is complete."

Write-Host ""
Write-Host "v1.0 release checklist validation passed."
