[CmdletBinding()]
param(
    [string]$KeyPath = "$HOME\.config\sops\age\keys.txt"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $KeyPath)) {
    Write-Error "Age key not found: $KeyPath"
    exit 1
}

$publicKeyLine = Select-String `
    -Path $KeyPath `
    -Pattern "^# public key: age1" |
    Select-Object -First 1

if (-not $publicKeyLine) {
    Write-Error "Unable to extract Age public key."
    exit 1
}

$publicKey = $publicKeyLine.Line.Replace(
    "# public key: ",
    ""
).Trim()

$sopsPath = ".sops.yaml"
$sopsContent = Get-Content $sopsPath -Raw

if ($sopsContent -notmatch "AGE_PUBLIC_KEY_REPLACE_ME") {
    Write-Error "Age public key placeholder was not found in .sops.yaml."
    exit 1
}

$sopsContent = $sopsContent.Replace(
    "AGE_PUBLIC_KEY_REPLACE_ME",
    $publicKey
)

[System.IO.File]::WriteAllText(
    (Join-Path $PWD $sopsPath),
    $sopsContent.TrimEnd([char]13, [char]10) + "`n",
    (New-Object System.Text.UTF8Encoding($false))
)

Write-Host "[INFO] Updated .sops.yaml with Age recipient."
