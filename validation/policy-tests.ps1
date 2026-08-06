$ErrorActionPreference = "Stop"

$requiredFiles = @(
    "policy-tests\kyverno-test.yaml",
    "policy-tests\fixtures\compliant\pod.yaml",
    "policy-tests\fixtures\noncompliant\privileged-pod.yaml",
    "policy-tests\fixtures\noncompliant\host-path-pod.yaml",
    "policy-tests\fixtures\noncompliant\host-namespace-pod.yaml",
    "policy-tests\fixtures\noncompliant\latest-tag-pod.yaml",
    "policy-tests\fixtures\noncompliant\missing-resources-pod.yaml",
    "policy-tests\fixtures\noncompliant\writable-root-pod.yaml",
    "policy-tests\fixtures\noncompliant\service-account-token-pod.yaml"
)

foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file)) {
        Write-Error "Required policy test file is missing: $file"
        exit 1
    }
}

$testDefinition = Get-Content "policy-tests\kyverno-test.yaml" -Raw

$requiredPolicies = @(
    "disallow-privileged",
    "disallow-host-path",
    "disallow-host-namespaces",
    "disallow-latest-tag",
    "require-resources",
    "require-read-only-root-filesystem",
    "disable-service-account-token",
    "require-non-root",
    "require-seccomp",
    "drop-capabilities",
    "require-standard-labels"
)

foreach ($policy in $requiredPolicies) {
    if ($testDefinition -notmatch [regex]::Escape($policy)) {
        Write-Error "Policy is not covered by the test suite: $policy"
        exit 1
    }
}

$passCount = (
    Select-String `
        -Path "policy-tests\kyverno-test.yaml" `
        -Pattern "result:\s+pass"
).Count

$failCount = (
    Select-String `
        -Path "policy-tests\kyverno-test.yaml" `
        -Pattern "result:\s+fail"
).Count

if ($passCount -lt 1) {
    Write-Error "No passing policy test results were defined."
    exit 1
}

if ($failCount -lt 1) {
    Write-Error "No failing policy test results were defined."
    exit 1
}

Write-Host "[INFO] Policy regression test structure validation passed."
Write-Host "[INFO] Passing expectations: $passCount"
Write-Host "[INFO] Failing expectations: $failCount"
