#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_SOURCE="${SCRIPT_SOURCE:-$(pwd)/backup/etcd/snapshot.sh}"
SCRIPT_TARGET="/usr/local/sbin/k3s-etcd-snapshot"
SERVICE_TARGET="/etc/systemd/system/k3s-etcd-snapshot.service"
TIMER_TARGET="/etc/systemd/system/k3s-etcd-snapshot.timer"

[[ "${EUID}" -eq 0 ]] || {
  printf '[ERROR] Run this script as root.\n' >&2
  exit 1
}

install -m 0755 "${SCRIPT_SOURCE}" "${SCRIPT_TARGET}"

cat > "${SERVICE_TARGET}" <<'EOF'
[Unit]
Description=Create and verify k3s etcd snapshot
Requires=k3s.service
After=k3s.service

[Service]
Type=oneshot
Environment=SNAPSHOT_NAME=scheduled
Environment=SNAPSHOT_RETENTION=14
ExecStart=/usr/local/sbin/k3s-etcd-snapshot
User=root
Group=root
NoNewPrivileges=true
PrivateTmp=true
ProtectHome=true
ProtectSystem=strict
ReadWritePaths=/var/lib/rancher/k3s/server/db/snapshots
EOF

cat > "${TIMER_TARGET}" <<'EOF'
[Unit]
Description=Run k3s etcd snapshot every six hours

[Timer]
OnCalendar=*-*-* 00/6:00:00
Persistent=true
RandomizedDelaySec=10m
Unit=k3s-etcd-snapshot.service

[Install]
WantedBy=timers.target
EOF

systemctl daemon-reload
systemctl enable --now k3s-etcd-snapshot.timer
systemctl status k3s-etcd-snapshot.timer --no-pager
