#!/bin/bash
set -euo pipefail

MODULE="sway"
TARGET_DIR="$HOME/.config/sway"
FILES=("config")
DIRS=("cfg")
RELOAD_CMD="swaymsg reload"
RELOAD_HINT="swaymsg reload"
PROJECT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

source "$PROJECT_DIR/lib/module-apply.sh"
