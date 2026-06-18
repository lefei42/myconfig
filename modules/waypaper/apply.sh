#!/bin/bash
set -euo pipefail

# ------ 模块声明 ------
MODULE="waypaper"
TARGET_DIR="$HOME/.config/waypaper"
FILES=("config.ini")
DIRS=()
PROJECT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

source "$PROJECT_DIR/lib/module-apply.sh"