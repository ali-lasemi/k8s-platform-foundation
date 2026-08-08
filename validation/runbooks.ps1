$ErrorActionPreference = "Stop"

$requiredFiles = @(
    "docs\runbooks\README.md",
    "docs\runbooks\incident-response.md",
    "docs\runbooks\severity-model.md",
    "docs\runbooks\initial-triage.md",
    "docs\runbooks\node-failure.md",
    "docs\runbooks\control-plane-failure.md",
    "docs\runbooks\flux-reconciliation-failure.md",
    "docs\runbooks\ingress-tls-dns-failure.md",
    "docs\runbooks\observability-failure.md",
    "docs\runbooks\backup-restore-failure.md",
    "docs\runbooks\secret-recovery.md",
    "docs\runbooks\upgrade-rollback.md",
    "docs\runbooks\on-call-handover.md",
    "docs\runbooks\post-incident-review.md"
)

foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file)) {
        Write-Error "Missing runbook: $file"
        exit 1
    }

    $content = Get-Content $file -Raw

    if ([string]::IsNullOrWhiteSpace($content)) {
        Write-Error "Runbook is empty: $file"
        exit 1
    }
}

$index = Get-Content "docs\runbooks\README.md" -Raw

$requiredLinks = @(
    "incident-response.md",
    "severity-model.md",
    "initial-triage.md",
    "node-failure.md",
    "control-plane-failure.md",
    "flux-reconciliation-failure.md",
    "ingress-tls-dns-failure.md",
    "observability-failure.md",
    "backup-restore-failure.md",
    "secret-recovery.md",
    "upgrade-rollback.md",
    "on-call-handover.md",
    "post-incident-review.md"
)

foreach ($link in $requiredLinks) {
    if ($index -notmatch [regex]::Escape($link)) {
        Write-Error "Runbook index is missing link: $link"
        exit 1
    }
}

Write-Host "[INFO] Production runbook validation passed."
