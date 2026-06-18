#!/bin/bash
set -euo pipefail

# ------ 交互式还原入口 ------
# 用法: ./restore.sh
# 流程：列出备份 → 用户选择 → 确认 → 调用 apply.sh --source 还原
# 还原本质是换源部署，复用 apply.sh 的文件拷贝逻辑

PROJECT_DIR="$(dirname "$0")"
BACKUP_DIR="$PROJECT_DIR/backup"

# ------ 扫描可用备份 ------
SNAPSHOTS=()
for d in "$BACKUP_DIR"/*/; do
    [ -d "$d" ] && SNAPSHOTS+=("$(basename "$d")")
done
# 按时间倒排，最新的备份排在最前
SNAPSHOTS=($(printf '%s\n' "${SNAPSHOTS[@]}" | sort -r))

# 无备份时退出
if [ ${#SNAPSHOTS[@]} -eq 0 ]; then
    echo "没有可用备份"
    exit 1
fi

# ------ 显示备份列表 ------
echo "可用备份:"
for i in "${!SNAPSHOTS[@]}"; do
    ts="${SNAPSHOTS[$i]}"
    # 获取该时间戳包含哪些模块
    modules=$(ls "$BACKUP_DIR/$ts" 2>/dev/null | tr '\n' ' ')
    # 将 20250618-153000 格式化为 2025-06-18 15:30
    pretty="${ts:0:4}-${ts:4:2}-${ts:6:2} ${ts:9:2}:${ts:11:2}"
    echo "  $((i+1))  $pretty  ($modules)"
done
echo "  0  退出"

# ------ 用户选择 ------
read -p "请选择 [0-${#SNAPSHOTS[@]}]: " choice
if [ "$choice" = "0" ] || [ -z "$choice" ]; then
    echo "已取消"
    exit 0
fi

TIMESTAMP="${SNAPSHOTS[$((choice-1))]}"
MODULES=($(ls "$BACKUP_DIR/$TIMESTAMP"))

# ------ 确认 ------
echo "将还原备份 $TIMESTAMP，包含: ${MODULES[*]}"
read -p "确认还原？(y/N) " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "已取消"
    exit 0
fi

# ------ 执行还原（复用 apply.sh --source）------
exec "$PROJECT_DIR/apply.sh" --source "backup/$TIMESTAMP" "${MODULES[@]}"
