#!/usr/bin/env bash

set -euo pipefail

DOWNLOAD_URL="https://github.com/Liwyd/old-3xui-wo-ssl/releases/download/yo-yo/x-ui-linux-amd64.tar_3.gz"

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Downloading x-ui..."
curl -fsSL -o "$TMP_DIR/x-ui.tar.gz" "$DOWNLOAD_URL"

echo "Extracting..."
tar zxf "$TMP_DIR/x-ui.tar.gz" -C "$TMP_DIR"

chmod +x \
    "$TMP_DIR/x-ui/x-ui" \
    "$TMP_DIR/x-ui/bin/xray-linux-amd64" \
    "$TMP_DIR/x-ui/x-ui.sh"

echo "Installing..."

sudo rm -rf /usr/local/x-ui

sudo cp -r "$TMP_DIR/x-ui" /usr/local/

sudo install -m 755 "$TMP_DIR/x-ui/x-ui.sh" /usr/bin/x-ui
sudo install -m 644 "$TMP_DIR/x-ui/x-ui.service.debian" /etc/systemd/system/x-ui.service

sudo systemctl daemon-reload
sudo systemctl enable x-ui >/dev/null
sudo systemctl restart x-ui

echo
echo "======================================="
echo "x-ui installed successfully."
echo "======================================="
echo

exec x-ui
