[CmdletBinding()]
param(
    [string]$OutputDirectory = "$HOME\.config\sops\age"
)

$ErrorActionPreference = "Stop"

function Fail {
    param([string]$Message)

    Write-Error $Message
    exit 1
}

if (-not (Get-Command age-keygen -ErrorAction SilentlyContinue)) {
    Fail "age-keygen is not installed or is not available in PATH."
}

New-Item `
    -ItemType Directory `
    -Path $OutputDirectory `
    -Force |
    Out-Null

$keyPath = Join-Path $OutputDirectory "keys.txt"

if (Test-Path $keyPath) {
    Fail "Age key already exists: $keyPath"
}

& age-keygen -o $keyPath

if ($LASTEXITCODE -ne 0) {
    Fail "Age key generation failed."
}

$publicKeyLine = Select-String `
    -Path $keyPath `
    -Pattern "^# public key: age1" |
    Select-Object -First 1

if (-not $publicKeyLine) {
    Fail "Unable to extract the Age public key."
}

$publicKey = $publicKeyLine.Line.Replace(
    "# public key: ",
    ""
).Trim()

Write-Host "[INFO] Age private key created: $keyPath"
Write-Host "[INFO] Age public key: $publicKey"
Write-Host "[IMPORTANT] Back up the private key outside Git."
Write-Host "[IMPORTANT] Replace AGE_PUBLIC_KEY_REPLACE_ME in .sops.yaml."
