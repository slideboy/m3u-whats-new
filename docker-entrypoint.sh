#!/bin/sh
set -eu

mkdir -p /data/backups

if [ ! -f /data/config.json ]; then
    cp /app/config.default.json /data/config.json
    echo "[OK] Configuration initiale créée dans /data/config.json"
fi

exec "$@"
