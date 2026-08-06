#!/usr/bin/env bash

set -Eeuo pipefail

CERT_DIR="${CERT_DIR:-/var/lib/rancher/k3s/server/tls}"
WARNING_DAYS="${WARNING_DAYS:-30}"

fail() {
  printf '[FAIL] %s\n' "$1" >&2
  exit 1
}

command -v openssl >/dev/null 2>&1 ||
  fail "openssl is required."

[[ -d "${CERT_DIR}" ]] ||
  fail "Certificate directory not found: ${CERT_DIR}"

warning_seconds="$((WARNING_DAYS * 86400))"
current_epoch="$(date +%s)"
failed=0

while IFS= read -r certificate; do
  expiry="$(
    openssl x509 \
      -in "${certificate}" \
      -noout \
      -enddate |
      cut -d= -f2-
  )"

  expiry_epoch="$(date -d "${expiry}" +%s)"
  remaining="$((expiry_epoch - current_epoch))"

  if (( remaining <= warning_seconds )); then
    printf '[WARN] Certificate nearing expiry: %s\n' "${certificate}"
    failed=1
  fi
done < <(
  find "${CERT_DIR}" \
    -type f \
    \( -name '*.crt' -o -name '*.pem' \) \
    -print
)

(( failed == 0 )) ||
  fail "One or more certificates expire within ${WARNING_DAYS} days."

printf '[INFO] Certificate expiry validation passed.\n'
