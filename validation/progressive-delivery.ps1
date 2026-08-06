$required=@(
"platform/flagger/release.yaml",
"platform/flagger/loadtester-release.yaml",
"progressive-delivery/canary/ingress-demo.yaml",
"progressive-delivery/blue-green/canary.yaml",
"progressive-delivery/metrics/request-success-rate.yaml",
"progressive-delivery/metrics/request-duration.yaml"
)

foreach($f in $required){
    if(!(Test-Path $f)){
        Write-Error "$f missing"
        exit 1
    }
}

Write-Host "Progressive Delivery validation passed."
