[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$InputFile,

    [string]$OutputFile
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command sops -ErrorAction SilentlyContinue)) {
    Write-Error "sops is not installed or is not available in PATH."
    exit 1
}

if (-not (Test-Path $InputFile)) {
    Write-Error "Encrypted file not found: $InputFile"
    exit 1
}

if (-not $InputFile.EndsWith(".enc.yaml")) {
    Write-Error "Input file must use the .enc.yaml suffix."
    exit 1
}

if (-not $OutputFile) {
    $OutputFile = $InputFile.Replace(
        ".enc.yaml",
        ".decrypted.yaml"
    )
}

$decryptedContent = & sops `
    --decrypt `
    --input-type yaml `
    --output-type yaml `
    $InputFile

if ($LASTEXITCODE -ne 0) {
    Write-Error "SOPS decryption failed."
    exit 1
}

[System.IO.File]::WriteAllText(
    (Join-Path $PWD $OutputFile),
    ($decryptedContent -join "`n") + "`n",
    (New-Object System.Text.UTF8Encoding($false))
)

Write-Host "[INFO] Decrypted file created locally: $OutputFile"
Write-Host "[IMPORTANT] Never commit decrypted files."
