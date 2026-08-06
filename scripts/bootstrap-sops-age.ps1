[CmdletBinding()]
param(
    [string]$KeyPath = "$HOME\.config\sops\age\keys.txt",
    [string]$Namespace = "flux-system",
    [string]$SecretName = "sops-age"
)

$ErrorActionPreference = "Stop"

function Require-Command {
    param([string]$Name)

    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        Write-Error "Required command not found: $Name"
        exit 1
    }
}

Require-Command "kubectl"

if (-not (Test-Path $KeyPath)) {
    Write-Error "Age private key not found: $KeyPath"
    exit 1
}

kubectl get namespace $Namespace *> $null

if ($LASTEXITCODE -ne 0) {
    Write-Error "Namespace not found: $Namespace"
    exit 1
}

kubectl create secret generic $SecretName `
    --namespace $Namespace `
    --from-file="age.agekey=$KeyPath" `
    --dry-run=client `
    -o yaml |
    kubectl apply -f -

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to create Flux SOPS Age secret."
    exit 1
}

kubectl label secret $SecretName `
    --namespace $Namespace `
    app.kubernetes.io/name=sops-age `
    app.kubernetes.io/part-of=k8s-platform-foundation `
    app.kubernetes.io/managed-by=bootstrap `
    --overwrite

Write-Host "[INFO] Flux SOPS Age secret is ready."
