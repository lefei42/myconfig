# myconfig

个人的 Arch Linux 桌面环境配置文件管理工具。模块化部署，支持按机器/场景切换配置。

## 目录结构

```
myconfig/
├── apply.sh                 # 主入口：参数解析、profile 匹配、分发模块
├── restore.sh               # 交互式还原：选择备份时间点 → 确认 → 还原
├── lib/
│   └── module-apply.sh      # 部署核心库：备份、拷贝、profile 覆盖、重载
├── modules/                 # 可复用配置模块
│   ├── niri/                # Niri compositor (config.kdl + cfg/)
│   ├── waybar/              # Waybar 状态栏 (config.jsonc, style.css)
│   ├── waypaper/            # 壁纸管理 (config.ini + scripts/)
│   └── wofi/                # 应用启动器 (config, style.css)
├── profiles/                # 配置集：按机器/场景组合模块
│   ├── default/             # 默认集: niri + waybar + waypaper + wofi
│   ├── desktop.niri-dms/    # niri + 双显示器扩展
│   └── desktop.sway/        # sway 场景
└── backup/                  # 备份目录 (gitignored)
```

## 核心概念

### 模块（Module）
每个桌面组件独立为一个模块。模块目录包含 `apply.sh` 和配置文件：
- `apply.sh` 声明 `MODULE`、`TARGET_DIR`、`FILES`、`DIRS`、重载命令
- 部署逻辑由 `lib/module-apply.sh` 统一处理

### 配置集（Profile）
Profile 是模块的组合 + 配置覆盖层：
- `profiles/<name>/profile.conf` 定义该 profile 包含哪些模块
- `profiles/<name>/modules/<module>/` 下的同名文件会覆盖模块的默认配置
- `profiles/<name>/modules/<module>/module.conf` 可扩展模块的 `FILES`/`DIRS`，实现按需引入额外配置文件

### 分层覆盖机制

```
模块基础配置 (modules/<name>/)
  ↓
Profile 覆盖 (profiles/<profile>/modules/<name>/)   ← 同名文件替换
  ↓
Module 扩展 (module.conf 追加 FILES/DIRS)            ← 按需引入
```

## 使用

```bash
# 根据 hostname 自动匹配 profile，部署全部模块
./apply.sh

# 指定 profile
./apply.sh -p desktop.sway

# 部署前先备份当前配置
./apply.sh -b

# 仅部署指定模块（可组合）
./apply.sh waybar niri

# 指定 profile + 仅部署指定模块
./apply.sh -p desktop.sway waybar

# 列出可用 profile
./apply.sh --list-profiles

# 交互式还原
./restore.sh
```

## 新增模块

1. 在 `modules/` 下创建目录，放入配置文件
2. 创建 `apply.sh`，声明模块变量：

```bash
#!/bin/bash
set -euo pipefail

MODULE="myapp"
TARGET_DIR="$HOME/.config/myapp"
FILES=("config.toml")
DIRS=("scripts")
RELOAD_CMD="systemctl --user restart myapp"

PROJECT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
source "$PROJECT_DIR/lib/module-apply.sh"
```

3. 在 profile 的 `profile.conf` 中加入模块名

## 新增 Profile

1. 创建 `profiles/<name>/profile.conf`：

```bash
MODULES=(niri waybar waypaper wofi)
```

2. 需要覆盖某个模块的配置时，创建 `profiles/<name>/modules/<module>/` 放入同名文件
3. 需要扩展模块的 `FILES`/`DIRS` 时，创建 `module.conf`：

```bash
FILES+=("extra-config.json")
DIRS+=("extra-dir")
```

## 备份与还原

- 部署时加 `-b`：将当前配置文件备份到 `backup/<时间戳>/`
- 运行 `./restore.sh`：交互式选择备份时间点还原

备份目录在 `.gitignore` 中，不会提交到仓库。
