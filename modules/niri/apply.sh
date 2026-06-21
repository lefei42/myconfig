#!/bin/bash
set -euo pipefail

# ------ 模块声明 ------
MODULE="niri"
TARGET_DIR="$HOME/.config/niri"
FILES=("config.kdl")
DIRS=("cfg" "dms")
RELOAD_HINT="niri msg action reload"
PROJECT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

source "$PROJECT_DIR/lib/module-apply.sh"
