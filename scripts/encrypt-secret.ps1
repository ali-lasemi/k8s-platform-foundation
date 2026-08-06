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
    Write-Error "Input file not found: $InputFile"
    exit 1
}

if (-not $OutputFile) {
    $directory = Split-Path $InputFile -Parent
    $name = [System.IO.Path]::GetFileNameWithoutExtension($InputFile)

    if ($name.EndsWith(".template")) {
        $name = $name.Substring(
            0,
            $name.Length - ".template".Length
        )
    }

    $OutputFile = Join-Path $directory "$name.enc.yaml"
}

$encryptedContent = & sops `
    --encrypt `
    --input-type yaml `
    --output-type yaml `
    $InputFile

if ($LASTEXITCODE -ne 0) {
    Write-Error "SOPS encryption failed."
    exit 1
}

[System.IO.File]::WriteAllText(
    (Join-Path $PWD $OutputFile),
    ($encryptedContent -join "`n") + "`n",
    (New-Object System.Text.UTF8Encoding($false))
)

Write-Host "[INFO] Encrypted secret created: $OutputFile"
