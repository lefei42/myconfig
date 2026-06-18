# ===== 模块通用部署库 =====
# 被各模块的 apply.sh 通过 source 加载
# 模块脚本需预先声明以下变量：
#   MODULE        模块名，如 "niri"
#   TARGET_DIR    目标配置目录，如 "$HOME/.config/niri"
#   FILES         要复制的文件列表，如 ("config.kdl")
#   DIRS          要复制的目录列表，如 ("cfg")，可选
#   RELOAD_CMD    重载命令，如 "killall -SIGUSR2 waybar"，可选
#   RELOAD_HINT   无命令时的重载提示，如 "niri msg action reload"，可选

# ------ 路径初始化 ------
SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="${PROJECT_DIR:-$(dirname "$SOURCE_DIR")}"

# ------ 参数解析 ------
# 兼容两种调用方式：
#   1. 位置参数（由根脚本 apply.sh 调用）：./模块/apply.sh <备份标志> <时间戳> [源覆盖路径]
#   2. 命名参数（独立运行）：./模块/apply.sh [--backup] [--timestamp 时间戳] [--source 路径]
BACKUP_ENABLED=false
TIMESTAMP=""

if [ $# -ge 1 ] && { [ "$1" = "true" ] || [ "$1" = "false" ]; }; then
    # 位置参数模式（根脚本调用）
    BACKUP_ENABLED="$1"
    TIMESTAMP="${2:-$(date +%Y%m%d-%H%M%S)}"
    SOURCE_OVERRIDE="${3:-}"
    [ -n "$SOURCE_OVERRIDE" ] && SOURCE_DIR="$SOURCE_OVERRIDE"
else
    # 命名参数模式（独立运行）
    while [ $# -gt 0 ]; do
        case "$1" in
            --backup|-b)      BACKUP_ENABLED=true ; shift ;;
            --timestamp|-t)   TIMESTAMP="$2" ; shift 2 ;;
            --source|-s)      SOURCE_DIR="$2" ; shift 2 ;;
            *) echo "✗ 未知选项: $1" ; exit 1 ;;
        esac
    done
    [ -z "$TIMESTAMP" ] && TIMESTAMP=$(date +%Y%m%d-%H%M%S)
fi

# ------ 前置校验 ------
for f in "${FILES[@]}"; do
    if [ ! -f "$SOURCE_DIR/$f" ]; then
        echo "✗ 源文件不存在: $SOURCE_DIR/$f"
        exit 1
    fi
done
for d in "${DIRS[@]-}"; do
    if [ ! -d "$SOURCE_DIR/$d" ]; then
        echo "✗ 源目录不存在: $SOURCE_DIR/$d"
        exit 1
    fi
done

[ ! -d "$TARGET_DIR" ] && mkdir -p "$TARGET_DIR"

# ------ 备份（可选）------
if [ "$BACKUP_ENABLED" = "true" ]; then
    BACKUP_DIR="$PROJECT_DIR/backup/$TIMESTAMP/$MODULE"
    mkdir -p "$BACKUP_DIR"
    for f in "${FILES[@]}"; do
        cp "$TARGET_DIR/$f" "$BACKUP_DIR/" 2>/dev/null || true
    done
    for d in "${DIRS[@]-}"; do
        [ -d "$TARGET_DIR/$d" ] && cp -r "$TARGET_DIR/$d" "$BACKUP_DIR/"
    done
    echo "→ 备份已保存至: $BACKUP_DIR"
fi

# ------ 部署 ------
for f in "${FILES[@]}"; do
    mkdir -p "$(dirname "$TARGET_DIR/$f")"
    cp "$SOURCE_DIR/$f" "$TARGET_DIR/$f"
done
for d in "${DIRS[@]-}"; do
    mkdir -p "$TARGET_DIR/$d"
    cp -r "$SOURCE_DIR/$d/"* "$TARGET_DIR/$d/" 2>/dev/null || true
done

echo "✓ $MODULE 配置已应用"

# ------ 重载 ------
if [ -n "${RELOAD_CMD:-}" ]; then
    if $RELOAD_CMD 2>/dev/null; then
        echo "  配置已重载"
    else
        echo "  ${RELOAD_HINT:-重载失败，请手动重载}"
    fi
else
    [ -n "${RELOAD_HINT:-}" ] && echo "  ${RELOAD_HINT:-}"
fi
