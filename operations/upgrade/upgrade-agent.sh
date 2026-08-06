#!/usr/bin/env bash

set -Eeuo pipefail

TARGET_VERSION="${TARGET_VERSION:-}"
K3S_URL="${K3S_URL:-}"
K3S_TOKEN="${K3S_TOKEN:-}"
CONFIRM_UPGRADE="${CONFIRM_UPGRADE:-false}"

fail() {
  printf '[ERROR] %s\n' "$1" >&2
  exit 1
}

[[ "${EUID}" -eq 0 ]] \
  || fail "Run this script as root."

[[ -n "${TARGET_VERSION}" ]] \
  || fail "TARGET_VERSION is required."

[[ -n "${K3S_URL}" ]] \
  || fail "K3S_URL is required."

[[ -n "${K3S_TOKEN}" ]] \
  || fail "K3S_TOKEN is required."

[[ "${CONFIRM_UPGRADE}" == "true" ]] \
  || fail "Set CONFIRM_UPGRADE=true to continue."

curl -sfL https://get.k3s.io \
  | INSTALL_K3S_VERSION="${TARGET_VERSION}" \
    K3S_URL="${K3S_URL}" \
    K3S_TOKEN="${K3S_TOKEN}" \
    sh -

systemctl restart k3s-agent
systemctl is-active --quiet k3s-agent
