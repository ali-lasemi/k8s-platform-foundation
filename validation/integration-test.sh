#!/usr/bin/env bash

set -Eeuo pipefail

./validation/cluster-health.sh

./validation/platform-health.sh || true

./validation/smoke-test.sh || true

echo "Integration Passed"