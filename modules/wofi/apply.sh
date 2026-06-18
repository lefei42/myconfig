#!/bin/bash
set -euo pipefail

# ------ 模块声明 ------
MODULE="wofi"
TARGET_DIR="$HOME/.config/wofi"
FILES=("config" "style.css")
DIRS=()
# RELOAD_CMD=""
# RELOAD_HINT=""
PROJECT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

source "$PROJECT_DIR/lib/module-apply.sh"
