#!/bin/bash
set -euo pipefail

# 全局变量初始化
BACKUP=false           # 是否备份当前配置
SOURCE_OVERRIDE=""     # 源路径覆盖（还原时指定 backup/时间戳）
PROFILE=""             # 配置集名称
PROFILE_DIR=""         # profiles/<profile>/ 路径
MODULES=()             # 要部署的模块列表

# 获取项目根目录
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ------ 参数解析 ------
# 支持参数任意顺序混用
#   --backup|-b     无值标志：部署前备份当前配置
#   --source|-s     有值标志：指定源路径覆盖（如 backup/20250618-153000）
#   --profile|-p    有值标志：指定配置集名称
#   --list-profiles 列出可用配置集
#   --help|-h       显示帮助
#   裸参数          模块名，如 waybar niri
while [ $# -gt 0 ]; do
    case "$1" in
        --backup|-b) BACKUP=true ; shift ;;

        --source|-s)
            SOURCE_OVERRIDE="$2"
            if [ ! -d "$PROJECT_DIR/$SOURCE_OVERRIDE" ]; then
                echo "✗ 源路径不存在: $PROJECT_DIR/$SOURCE_OVERRIDE"
                exit 1
            fi
            shift 2 ;;

        --profile|-p)
            PROFILE="$2"
            PROFILE_DIR="$PROJECT_DIR/profiles/$PROFILE"
            if [ ! -d "$PROFILE_DIR" ]; then
                echo "✗ profile 不存在: $PROFILE"
                echo "  可用: $(ls "$PROJECT_DIR/profiles" 2>/dev/null | tr '\n' ' ')"
                exit 1
            fi
            shift 2 ;;

        --list-profiles)
            echo "可用 profiles:"
            for p in "$PROJECT_DIR/profiles"/*/; do
                [ -d "$p" ] && echo "  $(basename "$p")"
            done
            exit 0 ;;

        --help|-h)
            echo "用法: ./apply.sh [选项] [模块...]"
            echo "  选项:"
            echo "    --backup|-b        先备份再部署"
            echo "    --source|-s <路径> 指定源路径覆盖（用于还原）"
            echo "    --profile|-p <名称> 指定配置集"
            echo "    --list-profiles    列出可用配置集"
            echo "    --help|-h          显示帮助"
            echo "  示例:"
            echo "    ./apply.sh                     自动匹配 hostname，使用对应 profile"
            echo "    ./apply.sh -p sixflydevice     指定 profile"
            echo "    ./apply.sh waybar              仅部署 waybar（无 profile 覆盖）"
            echo "    ./apply.sh -p sixflydevice waybar  仅部署 waybar（带 profile 覆盖）"
            exit 0 ;;

        -*)  # 拦截未知选项
            echo "✗ 未知选项: $1"
            echo "  可用选项: --backup|-b, --source|-s, --profile|-p, --list-profiles, --help|-h"
            exit 1 ;;

        *)  # 裸参数视为模块名，校验对应 apply.sh 是否存在
            if [ ! -f "$PROJECT_DIR/modules/$1/apply.sh" ]; then
                echo "✗ 未知模块: $1 (未找到 modules/$1/apply.sh)"
                exit 1
            fi
            MODULES+=("$1") ; shift ;;
    esac
done

# ------ Profile 自动匹配 ------
# 未指定 profile 且未传模块名 → 尝试用 hostname 匹配
if [ -z "$PROFILE" ] && [ ${#MODULES[@]} -eq 0 ] && [ -z "$SOURCE_OVERRIDE" ]; then
    HOST=$(cat /proc/sys/kernel/hostname 2>/dev/null || echo "")
    if [ -n "$HOST" ] && [ -d "$PROJECT_DIR/profiles/$HOST" ]; then
        PROFILE="$HOST"
        PROFILE_DIR="$PROJECT_DIR/profiles/$PROFILE"
        echo "→ 自动匹配 profile: $PROFILE"
    else
        echo "✗ 未指定 profile，且无匹配 hostname ($HOST) 的 profile"
        echo "  请使用 --profile 或 --list-profiles 查看可用配置"
        exit 1
    fi
fi

# ------ 从 profile.conf 获取模块列表 ------
# 仅在未通过裸参数指定模块时使用
if [ -n "$PROFILE" ] && [ ${#MODULES[@]} -eq 0 ]; then
    if [ -f "$PROFILE_DIR/profile.conf" ]; then
        source "$PROFILE_DIR/profile.conf"
        echo "→ 读取 profile: $PROFILE (${MODULES[*]})"
    else
        echo "✗ profile 缺少 profile.conf: $PROFILE_DIR/profile.conf"
        exit 1
    fi
fi

# 兼容旧用法：没有 profile 也没有模块时使用默认列表
if [ -z "$PROFILE" ] && [ ${#MODULES[@]} -eq 0 ]; then
    MODULES=(niri waybar waypaper wofi)
fi

# 统一时间戳
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# 导出 PROFILE 供 lib 使用
export PROFILE_DIR

# ------ 逐模块部署 ------
for module in "${MODULES[@]}"; do
    SCRIPT="$PROJECT_DIR/modules/$module/apply.sh"
    echo "▶ 部署 $module..."

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
