$ErrorActionPreference = "Stop"

$requiredFiles = @(
    "docs\architecture\README.md",
    "docs\architecture\platform-overview.md",
    "docs\architecture\component-map.md",
    "docs\architecture\gitops-flow.md",
    "docs\architecture\traffic-flow.md",
    "docs\architecture\observability-flow.md",
    "docs\architecture\secrets-flow.md",
    "docs\architecture\disaster-recovery-flow.md",
    "docs\architecture\progressive-delivery-flow.md",
    "docs\architecture\environment-promotion-flow.md"
)

foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file)) {
        Write-Error "Missing architecture document: $file"
        exit 1
    }

    $content = Get-Content $file -Raw

    if ($file -ne "docs\architecture\README.md") {
        if ($content -notmatch "```mermaid") {
            Write-Error "Mermaid diagram missing from: $file"
            exit 1
        }
    }
}

$index = Get-Content "docs\architecture\README.md" -Raw

$requiredLinks = @(
    "platform-overview.md",
    "component-map.md",
    "gitops-flow.md",
    "traffic-flow.md",
    "observability-flow.md",
    "secrets-flow.md",
    "disaster-recovery-flow.md",
    "progressive-delivery-flow.md",
    "environment-promotion-flow.md"
)

foreach ($link in $requiredLinks) {
    if ($index -notmatch [regex]::Escape($link)) {
        Write-Error "Architecture index is missing link: $link"
        exit 1
    }
}

Write-Host "[INFO] Architecture documentation validation passed."
