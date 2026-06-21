# myconfig

个人 Arch Linux 桌面环境配置文件管理工具。模块化部署 + Profile 分层覆盖，支持按机器/场景切换配置。

## 使用

```bash
# 根据 hostname 自动匹配 profile，部署全部模块
./apply.sh

# 指定 profile
./apply.sh -p desktop.sway

# 部署前备份
./apply.sh -b

# 仅部署指定模块
./apply.sh waybar niri

# 列出可用 profile
./apply.sh --list-profiles

# 交互式还原
./restore.sh
```

## 快速开始

| 想做什么 | 怎么做 |
|---|---|
| 新增模块 | 在 `modules/` 下创建目录，写 `apply.sh` 声明目标路径和文件列表 |
| 新增 profile | 创建 `profiles/<name>/profile.conf` 定义模块列表 |
| 覆盖模块配置 | 文件放入 `profiles/<name>/modules/<模块>/`，同名即覆盖 |
| 扩展模块文件集 | 创建 `profiles/<name>/modules/<模块>/module.conf`，追加 FILES/DIRS |
