#!/bin/sh
set -e
: "${PORT:=8080}"
: "${WSS_PATH:=/Telegram/@@Carzita15/Proxy}"
if [ -z "$UUID" ] || [ "$UUID" = "00000000-0000-0000-0000-000000000000" ]; then
  UUID=$(cat /proc/sys/kernel/random/uuid)
  echo "⚠️  Aucun UUID fourni, UUID généré : $UUID"
fi
case "$WSS_PATH" in /*) ;; *) WSS_PATH="/$WSS_PATH" ;; esac
export PORT UUID WSS_PATH
envsubst '${PORT} ${UUID} ${WSS_PATH}' < /etc/xray/config.template.json > /etc/xray/config.json
echo "Xray VLESS+WS sur le port $PORT, path $WSS_PATH"
/usr/local/bin/xray run -test -config /etc/xray/config.json
exec /usr/local/bin/xray run -config /etc/xray/config.json
