#!/bin/bash
set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="$HOME/.config/niri"
BACKUP_ENABLED="${1:-true}"

if [ "$BACKUP_ENABLED" != "false" ]; then
    BACKUP_DIR="$TARGET_DIR/backup/$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    cp "$TARGET_DIR/config.kdl" "$BACKUP_DIR/" 2>/dev/null || true
    [ -d "$TARGET_DIR/cfg" ] && cp -r "$TARGET_DIR/cfg" "$BACKUP_DIR/"
    echo "→ 备份已保存至: $BACKUP_DIR"
fi

mkdir -p "$TARGET_DIR/cfg"
cp "$SOURCE_DIR/config.kdl" "$TARGET_DIR/config.kdl"
cp "$SOURCE_DIR/cfg/"*.kdl "$TARGET_DIR/cfg/"

echo "✓ niri 配置已应用"
echo "  如需重载: niri msg action reload"
