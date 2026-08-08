$ErrorActionPreference = "Stop"

function Pass {
    param([string]$Message)
    Write-Host "[PASS] $Message"
}

function Fail {
    param([string]$Message)
    Write-Error "[FAIL] $Message"
    exit 1
}

$requiredPaths = @(
    ".github\workflows",
    "bootstrap",
    "cluster",
    "docs",
    "docs\architecture",
    "docs\runbooks",
    "environments",
    "gitops",
    "observability",
    "operations",
    "platform",
    "policy-tests",
    "progressive-delivery",
    "security",
    "validation"
)

foreach ($path in $requiredPaths) {
    if (-not (Test-Path $path)) {
        Fail "Required platform path is missing: $path"
    }
}

Pass "Required platform directories exist."

$requiredFiles = @(
    "README.md",
    "LICENSE",
    "SECURITY.md",
    "CONTRIBUTING.md",
    "CODE_OF_CONDUCT.md",
    "SUPPORT.md",
    "Makefile",
    ".yamllint.yml",
    ".markdownlint-cli2.yaml",
    ".gitleaks.toml",
    ".sops.yaml",
    "docs\architecture\README.md",
    "docs\runbooks\README.md",
    "docs\gitops-promotion.md",
    "docs\policy-testing.md",
    "validation\architecture-docs.ps1",
    "validation\runbooks.ps1",
    "validation\environment-promotion.ps1",
    "validation\policy-tests.ps1"
)

foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file)) {
        Fail "Required production file is missing: $file"
    }
}

Pass "Required production files exist."

$environmentPaths = @(
    "environments/dev",
    "environments/staging",
    "environments/production"
)

if (Get-Command kubectl -ErrorAction SilentlyContinue) {
    foreach ($environment in $environmentPaths) {
        kubectl kustomize $environment *> $null

        if ($LASTEXITCODE -ne 0) {
            Fail "Kustomize rendering failed: $environment"
        }

        Pass "Kustomize rendering succeeded: $environment"
    }
}
else {
    Write-Host "[SKIP] kubectl is not installed; environment rendering deferred to CI."
}

$policyFiles = Get-ChildItem `
    "security\policies\kyverno" `
    -Filter "*.yaml" `
    -File

if ($policyFiles.Count -lt 1) {
    Fail "No Kyverno policy manifests found."
}

Pass "Kyverno policy inventory exists."

$workflowFiles = Get-ChildItem `
    ".github\workflows" `
    -Filter "*.yml" `
    -File

if ($workflowFiles.Count -lt 10) {
    Fail "Expected production CI workflow inventory is incomplete."
}

Pass "GitHub Actions workflow inventory exists."

$architectureDocs = Get-ChildItem `
    "docs\architecture" `
    -Filter "*.md" `
    -File

if ($architectureDocs.Count -lt 8) {
    Fail "Architecture documentation inventory is incomplete."
}

Pass "Architecture documentation inventory exists."

$runbooks = Get-ChildItem `
    "docs\runbooks" `
    -Filter "*.md" `
    -File

if ($runbooks.Count -lt 10) {
    Fail "Production runbook inventory is incomplete."
}

Pass "Production runbook inventory exists."

$placeholderPatterns = @(
    "TODO",
    "FIXME"
)

$searchFiles = Get-ChildItem `
    -Recurse `
    -File `
    -Include "*.yaml","*.yml","*.md","*.sh","*.ps1"

foreach ($pattern in $placeholderPatterns) {
    $matches = $searchFiles |
        Select-String `
            -Pattern $pattern `
            -SimpleMatch

    if ($matches) {
        Write-Host "[WARN] Found '$pattern' markers:"
        $matches |
            ForEach-Object {
                Write-Host "       $($_.Path):$($_.LineNumber)"
            }
    }
}

Pass "Repository production-readiness inventory validation completed."

Write-Host ""
Write-Host "Production readiness foundation checks passed."
