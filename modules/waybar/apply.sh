#!/bin/bash
set -euo pipefail

# ------ 模块声明 ------
MODULE="waybar"
TARGET_DIR="$HOME/.config/waybar"
FILES=("config.jsonc" "style.css")
DIRS=()
RELOAD_CMD="killall -SIGUSR2 waybar"
RELOAD_HINT="请手动重载: pkill waybar && waybar &"
PROJECT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

source "$PROJECT_DIR/lib/module-apply.sh"
