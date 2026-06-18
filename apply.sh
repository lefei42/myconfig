#!/bin/bash
set -euo pipefail

# 全局变量初始化
BACKUP=false           # 是否备份当前配置
SOURCE_OVERRIDE=""     # 源路径覆盖（还原时指定 backup/时间戳）
MODULES=()             # 要部署的模块列表

# 获取项目根目录
PROJECT_DIR="$(dirname "$0")"

# ------ 参数解析 ------
# 支持参数任意顺序混用
#   --backup|-b   无值标志：部署前备份当前配置
#   --source|-s   有值标志：指定源路径覆盖（如 backup/20250618-153000）
#   --help|-h     显示帮助
#   裸参数          模块名，如 waybar niri
while [ $# -gt 0 ]; do
    case "$1" in
        --backup|-b) BACKUP=true ; shift ;;

        --source|-s)
            SOURCE_OVERRIDE="$2"
            # 校验源路径是否存在
            if [ ! -d "$PROJECT_DIR/$SOURCE_OVERRIDE" ]; then
                echo "✗ 源路径不存在: $PROJECT_DIR/$SOURCE_OVERRIDE"
                exit 1
            fi
            shift 2 ;;

        --help|-h)
            echo "用法: ./apply.sh [选项] [模块...]"
            echo "  选项:  --backup|-b  先备份再部署"
            echo "         --source|-s  指定源路径覆盖（用于还原）"
            echo "         --help|-h    显示帮助"
            echo "  示例:  ./apply.sh                部署全部"
            echo "         ./apply.sh waybar         仅部署 waybar"
            echo "         ./apply.sh -b niri        备份后部署 niri"
            exit 0 ;;

        -*)  # 拦截未知选项
            echo "✗ 未知选项: $1"
            echo "  可用选项: --backup|-b, --source|-s, --help|-h"
            exit 1 ;;

        *)  # 裸参数视为模块名，校验对应 apply.sh 是否存在
            if [ ! -f "$PROJECT_DIR/modules/$1/apply.sh" ]; then
                echo "✗ 未知模块: $1 (未找到 modules/$1/apply.sh)"
                exit 1
            fi
            MODULES+=("$1") ; shift ;;
    esac
done

# 未指定模块时默认部署全部
[ ${#MODULES[@]} -eq 0 ] && MODULES=(
    niri
    waybar
    waypaper
    wofi
    )

# 统一时间戳，所有模块在同一次部署中共享同一时间戳
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# ------ 逐模块部署 ------
for module in "${MODULES[@]}"; do
    SCRIPT="$PROJECT_DIR/modules/$module/apply.sh"
    echo "▶ 部署 $module..."

    # 每个模块的 apply.sh 接收 2~3 个参数：
    #   $1 备份标志（true/false）
    #   $2 统一时间戳
    #   $3 源路径覆盖（可选，还原时传入）
    SCRIPT_ARGS=("$BACKUP" "$TIMESTAMP")
    if [ -n "$SOURCE_OVERRIDE" ]; then
        SRC_PATH="$PROJECT_DIR/$SOURCE_OVERRIDE/$module"
        if [ ! -d "$SRC_PATH" ] && [ ! -f "$SRC_PATH" ]; then
            echo "✗ 源路径不存在: $SRC_PATH"
            exit 1
        fi
        SCRIPT_ARGS+=("$SRC_PATH")
    fi

    "$SCRIPT" "${SCRIPT_ARGS[@]}"
done
