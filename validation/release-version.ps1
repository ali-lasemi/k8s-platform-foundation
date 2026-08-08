$ErrorActionPreference = "Stop"

function Fail {
    param([string]$Message)

    Write-Error "[FAIL] $Message"
    exit 1
}

if (-not (Test-Path "VERSION")) {
    Fail "VERSION file is missing."
}

$version = (Get-Content "VERSION" -Raw).Trim()

if ($version -notmatch '^[0-9]+\.[0-9]+\.[0-9]+$') {
    Fail "VERSION is not valid Semantic Versioning: $version"
}

if (-not (Test-Path "CHANGELOG.md")) {
    Fail "CHANGELOG.md is missing."
}

$changelog = Get-Content "CHANGELOG.md" -Raw

if ($changelog -notmatch [regex]::Escape("[$version]")) {
    Fail "CHANGELOG does not contain release version $version."
}

if (-not (Test-Path "docs\release-process.md")) {
    Fail "Release process documentation is missing."
}

Write-Host "[PASS] Release version: $version"
Write-Host "[PASS] CHANGELOG entry exists."
Write-Host "[PASS] Release process documentation exists."
