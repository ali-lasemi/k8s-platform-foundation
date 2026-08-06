[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$NewRecipient,

    [string]$SecretsPath = "secrets"
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command sops -ErrorAction SilentlyContinue)) {
    Write-Error "sops is not installed or is not available in PATH."
    exit 1
}

if ($NewRecipient -notmatch "^age1[0-9a-z]+$") {
    Write-Error "Invalid Age recipient."
    exit 1
}

if (-not (Test-Path ".sops.yaml")) {
    Write-Error ".sops.yaml was not found."
    exit 1
}

if (-not (Test-Path $SecretsPath)) {
    Write-Error "Secrets directory was not found: $SecretsPath"
    exit 1
}

$sopsContent = Get-Content ".sops.yaml" -Raw

if (
    $sopsContent -notmatch "AGE_PUBLIC_KEY_REPLACE_ME" -and
    $sopsContent -notmatch "age1[0-9a-z]+"
) {
    Write-Error "No Age recipient was found in .sops.yaml."
    exit 1
}

$updatedConfig = $sopsContent -replace `
    "AGE_PUBLIC_KEY_REPLACE_ME|age1[0-9a-z]+", `
    $NewRecipient

[System.IO.File]::WriteAllText(
    (Join-Path $PWD ".sops.yaml"),
    $updatedConfig.TrimEnd([char]13, [char]10) + "`n",
    (New-Object System.Text.UTF8Encoding($false))
)

$encryptedFiles = Get-ChildItem `
    $SecretsPath `
    -Recurse `
    -File `
    -Filter "*.enc.yaml"

foreach ($file in $encryptedFiles) {
    & sops updatekeys `
        --yes `
        $file.FullName

    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to rotate recipient for $($file.FullName)"
        exit 1
    }
}

Write-Host "[INFO] SOPS Age recipient rotation completed."
Write-Host "[IMPORTANT] Bootstrap the new private key into Flux."
Write-Host "[IMPORTANT] Verify reconciliation before removing the old key."
