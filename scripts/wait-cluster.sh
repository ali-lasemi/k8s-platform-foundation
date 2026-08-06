#!/usr/bin/env bash

set -Eeuo pipefail

kubectl wait \
node \
--all \
--for=condition=Ready \
--timeout=300s

kubectl wait \
pods \
-A \
--for=condition=Ready \
--timeout=300s