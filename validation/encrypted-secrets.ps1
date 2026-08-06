$ErrorActionPreference = "Stop"

$encryptedFiles = Get-ChildItem `
    "secrets" `
    -Recurse `
    -File `
    -Filter "*.enc.yaml"

foreach ($file in $encryptedFiles) {
    $content = Get-Content $file.FullName -Raw

    if ($content -notmatch "(?m)^sops:") {
        Write-Error "Missing SOPS metadata: $($file.FullName)"
        exit 1
    }

    if ($content -match "replace-me") {
        Write-Error "Placeholder value found in encrypted secret: $($file.FullName)"
        exit 1
    }

    if ($content -match "(?m)^\s+(password|token|secret|apiKey):\s+[^E]") {
        Write-Error "Possible plaintext secret detected: $($file.FullName)"
        exit 1
    }
}

Write-Host "[INFO] Encrypted secret validation passed."
