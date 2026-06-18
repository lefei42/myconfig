# niri 默认配置参考文档

> 来源：`def_config.kdl` — niri 提供的默认配置文件，作为自定义配置的参考基准。
>
> 官方文档：https://niri-wm.github.io/niri/Configuration:-Introduction

---

## 1. 文件概述

```kdl
// 此配置文件采用 KDL 格式：https://kdl.dev
// "/-" 用于注释掉下一个节点。
// 查看 wiki 获取完整的配置说明：
// https://niri-wm.github.io/niri/Configuration:-Introduction
```

---

## 2. 输入设备 — `input {}`

> 官方文档：https://niri-wm.github.io/niri/Configuration:-Input

```kdl
input {
```

### 2.1 键盘 — `keyboard`

可设置 rules、model、layout、variant 和 options。更多信息请参阅 `xkeyboard-config(7)`。
如果此部分为空，niri 将从 `org.freedesktop.locale1` 获取 xkb 设置。可以使用 `localectl set-x11-keymap` 来控制这些设置。

`numlock`：启动时启用数字锁定，省略此设置则禁用。

```kdl
    keyboard {
        xkb {
            // 可设置 rules、model、layout、variant 和 options。
            // 更多信息请参阅 xkeyboard-config(7)。
            //
            // 例如：
            // layout "us,ru"
            // options "grp:win_space_toggle,compose:ralt,ctrl:nocaps"
            //
            // 如果此部分为空，niri 将从 org.freedesktop.locale1 获取 xkb 设置。
            // 你可以使用 localectl set-x11-keymap 来控制这些设置。
        }

        // 启动时启用数字锁定，省略此设置则禁用。
        numlock
    }
```

### 2.2 触摸板 — `touchpad`

接下来的部分包含 libinput 设置。省略设置将禁用它们，或保留为默认值。此处所有被注释掉的设置仅为示例，并非默认值。

```kdl
    // 接下来的部分包含 libinput 设置。
    // 省略设置将禁用它们，或保留为默认值。
    // 此处所有被注释掉的设置仅为示例，并非默认值。
    touchpad {
        // off                              — 禁用触摸板
        tap                                 — 启用轻触点击
        // dwt                              — 敲击时禁用触摸板
        // dwtp                             — 打字时禁用触摸板
        // drag false                       — 禁用拖拽
        // drag-lock                        — 启用拖拽锁定
        natural-scroll                      — 启用自然滚动
        // accel-speed 0.2                  — 加速度
        // accel-profile "flat"             — 加速度配置文件
        // scroll-method "two-finger"       — 双指滚动
        // disabled-on-external-mouse       — 外接鼠标时禁用触摸板
    }
```

### 2.3 鼠标 — `mouse`

```kdl
    mouse {
        // off
        // natural-scroll
        // accel-speed 0.2
         accel-profile "flat"               — 加速度配置文件设为平面
        // scroll-method "no-scroll"
    }
```

### 2.4 指点杆 — `trackpoint`

```kdl
    trackpoint {
        // off
        // natural-scroll
        // accel-speed 0.2
        // accel-profile "flat"
        // scroll-method "on-button-down"   — 按住按钮时滚动
        // scroll-button 273                — 滚动按钮
        // scroll-button-lock
        // middle-emulation                 — 中键模拟
    }
```

### 2.5 其他输入设置

```kdl
    // 取消注释可使鼠标自动移动到新聚焦窗口的中心。
    // warp-mouse-to-focus

    // 当鼠标移入窗口或输出时自动聚焦。
    // 设置 max-scroll-amount="0%" 使其仅对完全显示在屏幕上的窗口生效。
    // focus-follows-mouse max-scroll-amount="0%"
}
```

---

## 3. 显示器输出 — `output {}`

> 官方文档：https://niri-wm.github.io/niri/Configuration:-Outputs

通过输出名称进行配置，可在 niri 实例内运行 `niri msg outputs` 查看。内置笔记本显示器通常名为 `"eDP-1"`。取消注释需移除前面的 `"/-"`。

```kdl
// 可通过名称配置输出，在 niri 实例内运行 `niri msg outputs` 可找到名称。
// 内置笔记本显示器通常名为 "eDP-1"。
// 在 wiki 上查看更多信息：
// https://niri-wm.github.io/niri/Configuration:-Outputs
// 记住取消注释节点需要移除 "/-"！
output "eDP-1" {
    // 取消注释此行可禁用此输出。
    // off

    // 输出的分辨率以及可选的刷新率。
    // 格式为 "<宽>x<高>" 或 "<宽>x<高>@<刷新率>"。
    // 如果省略刷新率，niri 将为该分辨率选择最高的刷新率。
    // 如果完全省略 mode 或 mode 无效，niri 将自动选择一个。
    // 在 niri 实例内运行 `niri msg outputs` 可列出所有输出及其模式。
    mode "1920x1080@144"

    // 可以使用整数或分数缩放，例如使用 1.5 表示 150% 缩放。
    scale 1.2

    // Transform 可以逆时针旋转输出，有效值为：
    // normal, 90, 180, 270, flipped, flipped-90, flipped-180, flipped-270。
    transform "normal"

    // 输出在全局坐标空间中的位置。
    // 这会影响方向性显示器操作（如 "focus-monitor-left"）和光标移动。
    // 光标只能在直接相邻的输出之间移动。
    // 定位时需要考虑输出的缩放和旋转：
    // 输出以逻辑像素（或称缩放像素）为单位进行尺寸计算。
    // 例如，3840×2160 的输出在 scale 2.0 时逻辑尺寸为 1920×1080，
    // 因此要将另一个输出放在其右侧相邻位置，需将其 x 设为 1920。
    // 如果未设置位置或位置导致重叠，则输出将自动放置。
    position x=1280 y=0
}
```

---

## 4. 布局 — `layout {}`

> 官方文档：https://niri-wm.github.io/niri/Configuration:-Layout

影响窗口定位和大小的设置。

```kdl
layout {
```

### 4.1 间距 — `gaps`

设置窗口周围的间距，以逻辑像素为单位。

```kdl
    // 设置窗口周围的间距（逻辑像素）。
    gaps 8
```

### 4.2 列居中 — `center-focused-column`

切换焦点时何时居中显示列：

- `"never"`（默认）：聚焦屏幕外的列将保持左对齐或右对齐
- `"always"`：聚焦的列将始终居中
- `"on-overflow"`：如果聚焦的列无法与之前聚焦的列同时显示，则居中

```kdl
    // 切换焦点时何时居中显示列，选项如下：
    // - "never", 默认行为，聚焦屏幕外的列将保持左对齐或右对齐。
    // - "always", 聚焦的列将始终居中。
    // - "on-overflow", 聚焦的列将居中（如果它无法与之前聚焦的列同时显示）。
    center-focused-column "never"
```

### 4.3 预设列宽 — `preset-column-widths`

可自定义 `switch-preset-column-width`（`Mod+R`）切换的宽度。

```kdl
    // 可自定义 "switch-preset-column-width" (Mod+R) 切换的宽度。
    preset-column-widths {
        // Proportion 将宽度设置为输出宽度的比例，考虑间距。
        // 例如，可完美容纳四个宽度为 "proportion 0.25" 的窗口。
        // 默认预设宽度为输出的 1/3、1/2 和 2/3。
        proportion 0.33333
        proportion 0.5
        proportion 0.66667

        // Fixed 以逻辑像素精确设置宽度。
        // fixed 1920
    }
```

### 4.4 窗口高度预设 — `preset-window-heights`

> 默认注释，未启用。

```kdl
    // 也可自定义 "switch-preset-window-height" (Mod+Ctrl+Shift+R) 切换的高度。
    // preset-window-heights { }
```

### 4.5 默认列宽 — `default-column-width`

可更改新窗口的默认宽度。如果括号为空，窗口自身将决定其初始宽度。

```kdl
    // 可更改新窗口的默认宽度。
    default-column-width { proportion 0.5; }
    // 如果括号为空，窗口自身将决定其初始宽度。
    // default-column-width {}
```

### 4.6 默认渲染行为说明

```kdl
    // 默认情况下，聚焦环和边框渲染为窗口后面的实色矩形。
    // 也就是说，它们会通过半透明窗口显示出来。
    // 这是因为使用客户端装饰（CSD）的窗口可以有任意形状。
    //
    // 如果不喜欢这样，应取消下面的 `prefer-no-csd` 注释。
    // Niri 会将聚焦环和边框绘制在*同意省略*客户端装饰的窗口*外围*。
    //
    // 或者，也可以使用名为 `draw-border-with-background` 的窗口规则覆盖。
```

### 4.7 聚焦环 — `focus-ring`

```kdl
    // 可更改聚焦环的外观。
    focus-ring {
        // 取消注释此行可禁用聚焦环。
        // off

        // 聚焦环从窗口向外延伸的逻辑像素数。
        width 1

        // 颜色可以通过多种方式设置：
        // - CSS 命名颜色："red"
        // - RGB 十六进制："#rgb"、"#rgba"、"#rrggbb"、"#rrggbbaa"
        // - CSS 风格的表示法："rgb(255, 127, 0)"、rgba()、hsl() 等。

        // 活动显示器上聚焦环的颜色。
        active-color "#7fc8ff"

        // 非活动显示器上聚焦环的颜色。
        // 聚焦环只绘制在活动窗口周围，因此唯一能看到 inactive-color 的地方是其他显示器。
        inactive-color "#505050"

        // 也可以使用渐变。渐变优先于纯色。
        // 渐变的渲染方式与 CSS linear-gradient(angle, from, to) 相同。
        // angle 与 linear-gradient 中的角度相同，为可选参数，默认值为 180（从上到下渐变）。
        // 可使用网上的 CSS linear-gradient 工具来设置。
        // 也支持更改色彩空间，更多信息请查看 wiki。
        //
        // active-gradient from="#80c8ff" to="#c7ff7f" angle=45

        // 也可以相对于工作区的整个视图来着色渐变，而不仅仅是相对于窗口本身。
        // 为此，设置 relative-to="workspace-view"。
        //
        // inactive-gradient from="#505050" to="#808080" angle=45 relative-to="workspace-view"
    }
```

### 4.8 边框 — `border`

与聚焦环类似，但始终可见。如果启用了边框，建议禁用聚焦环。

```kdl
    // 你也可以添加边框。它与聚焦环类似，但始终可见。
    border {
        // 设置与聚焦环相同。
        // 如果启用边框，你可能想禁用聚焦环。
        off

        width 4
        active-color "#ffc87f"
        inactive-color "#505050"

        // 请求注意的窗口周围边框颜色。
        urgent-color "#9b0000"

        // 渐变可以使用不同的插值色彩空间。
        // 例如，这是一个通过 in="oklch longer hue" 实现的粉彩彩虹渐变。
        //
        // active-gradient from="#e5989b" to="#ffb4a2" angle=45 relative-to="workspace-view" in="oklch longer hue"
        //
        // inactive-gradient from="#505050" to="#808080" angle=45 relative-to="workspace-view"
    }
```

### 4.9 阴影 — `shadow`

```kdl
    // 可以为窗口启用投影。
    shadow {
        // 取消注释下一行以启用阴影。
        // on

        // 默认情况下，阴影只绘制在窗口周围，而不是窗口后面。
        // 取消注释此设置可使阴影绘制在窗口后面。
        //
        // 注意，niri 无法获知 CSD 窗口的圆角半径。它必须假定窗口为方角，
        // 这会导致 CSD 圆角内部出现阴影伪影。此设置可修复这些伪影。
        //
        // 不过，你可以设置 prefer-no-csd 和/或 geometry-corner-radius。
        // 这样 niri 将知道圆角半径并正确绘制阴影，无需将其绘制在窗口后面。
        // 这些设置还会移除窗口绘制的客户端阴影（如有）。
        //
        // draw-behind-window true

        // 可更改阴影外观。以下值为逻辑像素，与 CSS box-shadow 属性匹配。

        // Softness 控制阴影模糊半径。
        softness 30

        // Spread 扩展阴影。
        spread 5

        // Offset 将阴影相对于窗口移动。
        offset x=0 y=5

        // 也可以更改阴影颜色和不透明度。
        color "#0007"
    }
```

### 4.10 Strut — `struts`

Strut 会缩小窗口占据的区域，类似于 layer-shell 面板。可将其视为一种外间距，以逻辑像素为单位。

```kdl
    // Struts 会缩小窗口占据的区域，类似于 layer-shell 面板。
    // 可将其视为一种外间距，以逻辑像素为单位。
    // 左和右 strut 会使侧边的下一个窗口始终可见。
    // 上和下 strut 会在 layer-shell 面板和常规间距之外额外添加外间距。
    struts {
          left -4
          right -4
          top -6
          bottom -4
    }
}
```

---

## 5. 启动程序 — `spawn-at-startup`

添加像这样的行可在启动时生成进程。注意，将 niri 作为会话运行时支持 `xdg-desktop-autostart`，使用起来可能更方便。请参阅下方 binds 部分获取更多 spawn 示例。

```kdl
// 添加像这样的行可在启动时生成进程。
// 注意，将 niri 作为会话运行时支持 xdg-desktop-autostart，可能更方便。
// 请参阅下面的 binds 部分获取更多 spawn 示例。

// 这行启动 waybar，一个常用的 Wayland 合成器状态栏。
spawn-at-startup "waybar"

// 要运行 shell 命令（带变量、管道等），请使用 spawn-sh-at-startup：
// spawn-sh-at-startup "qs -c ~/source/qs/MyAwesomeShell"
```

---

## 6. 快捷键覆盖提示 — `hotkey-overlay`

```kdl
hotkey-overlay {
    // 取消注释此行可禁用启动时的"重要快捷键"弹出提示。
    // skip-at-startup
}
```

---

## 7. 客户端装饰 — `prefer-no-csd`

请求客户端在可能的情况下省略客户端装饰。

```kdl
// 取消注释此行可请求客户端在可能的情况下省略客户端装饰。
// 如果客户端明确要求 CSD，该请求将被尊重。
// 此外，客户端将被告知它们处于平铺状态，从而移除一些客户端的圆角。
// 此选项还将修复某些半透明窗口后面的边框/聚焦环绘制问题。
// 启用或禁用此选项后，需要重启应用程序才能生效。
prefer-no-csd
```

---

## 8. 截图路径 — `screenshot-path`

```kdl
// 可更改截图的保存路径。
// 开头的 ~ 将被展开为主目录。
// 路径使用 strftime(3) 格式化以包含截图日期和时间。
screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

// 也可将其设置为 null 以禁用将截图保存到磁盘。
// screenshot-path null
```

---

## 9. 动画 — `animations`

> 官方文档：https://niri-wm.github.io/niri/Configuration:-Animations

```kdl
// 动画设置。
// wiki 解释了如何配置单个动画：
// https://niri-wm.github.io/niri/Configuration:-Animations
animations {
    // 取消注释可关闭所有动画。
    // off

    // 将所有动画减慢此倍数。小于 1 的值会加速动画。
    // slowdown 3.0
}
```

---

## 10. 窗口规则 — `window-rule`

> 官方文档：https://niri-wm.github.io/niri/Configuration:-Window-Rules

窗口规则用于调整单个窗口的行为。

### 10.1 WezTerm 初始配置兼容

```kdl
// 通过设置空的 default-column-width 解决 WezTerm 的初始配置 bug。
window-rule {
    // 此正则表达式特意做得尽可能具体，
    // 因为这是默认配置，我们希望避免误匹配。
    // 如果愿意，可以直接用 app-id="wezterm"。
    match app-id=r#"^org\.wezfurlong\.wezterm$"#
    default-column-width {}
}
```

### 10.2 Firefox 画中画浮动

```kdl
// 默认以浮动方式打开 Firefox 画中画播放器。
window-rule {
    // 此 app-id 正则表达式对以下两者均适用：
    // - 主机版 Firefox（app-id 为 "firefox"）
    // - Flatpak 版 Firefox（app-id 为 "org.mozilla.firefox"）
    match app-id=r#"firefox$"# title="^Picture-in-Picture$"
    open-floating true
}
```

### 10.3 密码管理器屏蔽（已注释示例）

```kdl
// 示例：屏蔽两个密码管理器，使其不被屏幕捕获。
//（此示例规则前带有 "/-" 注释）
/-window-rule {
    match app-id=r#"^org\.keepassxc\.KeePassXC$"#
    match app-id=r#"^org\.gnome\.World\.Secrets$"#

    block-out-from "screen-capture"

    // 如果希望它们对第三方截图工具可见，请使用下面的设置：
    // block-out-from "screencast"
}
```

### 10.4 全局圆角（已注释示例）

```kdl
// 示例：为所有窗口启用圆角。
//（此示例规则前带有 "/-" 注释）
window-rule {
    geometry-corner-radius 8
    clip-to-geometry true
}
```

---

## 11. 按键绑定 — `binds {}`

> 大多数动作也可以通过 `niri msg action do-something` 以编程方式调用。

### 11.1 基本说明

```kdl
binds {
    // 按键由用 + 号连接的修饰符组成，最后跟一个 XKB 按键名称。
    // 要查找特定按键的 XKB 名称，可使用 wev 等程序。
    //
    // "Mod" 是一个特殊修饰符，在 TTY 下等于 Super，在 winit 窗口下等于 Alt。
    //
    // 此处绑定的大多数动作也可以通过 `niri msg action do-something` 以编程方式调用。
```

### 11.2 快捷键覆盖

```kdl
    // Mod-Shift-/（通常等同于 Mod-?）显示重要快捷键列表。
    Mod+Shift+Slash { show-hotkey-overlay; }
```

### 11.3 启动程序

```kdl
    // 推荐绑定：终端、应用启动器、屏幕锁定
    Mod+T hotkey-overlay-title="打开终端: kitty" { spawn "kitty"; }
    Mod+D hotkey-overlay-title="运行应用: fuzzel" { spawn "fuzzel"; }
    Super+Alt+L hotkey-overlay-title="锁定屏幕: swaylock" { spawn "swaylock"; }
    Mod+space {spawn "sh" "-c" "pkill wofi || wofi";}

    // 使用 spawn-sh 运行 shell 命令。适用于需要管道、多条命令等情况。
    // 注意：整个命令作为一个参数传入，原样传递给 `sh -c`。
    // 例如，这是一个切换屏幕阅读器 (orca) 的标准绑定。
    Super+Alt+S allow-when-locked=true hotkey-overlay-title=null { spawn-sh "pkill orca || exec orca"; }
```

### 11.4 硬件键 — 音量

```kdl
    // PipeWire & WirePlumber 的音量键映射示例。
    // allow-when-locked=true 使其在锁屏时也能工作。
    // 使用 spawn-sh 可将多个参数与命令一起传递。
    // "-l 1.0" 将音量限制在 100%。
    XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0"; }
    XF86AudioLowerVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"; }
    XF86AudioMute        allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
    XF86AudioMicMute     allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }
```

### 11.5 硬件键 — 媒体控制

使用 playerctl，适用于任何支持 MPRIS 的媒体播放器。

```kdl
    // 使用 playerctl 的媒体键映射示例。
    // 适用于任何支持 MPRIS 的媒体播放器。
    XF86AudioPlay        allow-when-locked=true { spawn-sh "playerctl play-pause"; }
    XF86AudioStop        allow-when-locked=true { spawn-sh "playerctl stop"; }
    XF86AudioPrev        allow-when-locked=true { spawn-sh "playerctl previous"; }
    XF86AudioNext        allow-when-locked=true { spawn-sh "playerctl next"; }
```

### 11.6 硬件键 — 亮度

使用 brightnessctl。也可以使用普通 spawn（避免经过 "sh"），但需要手动将每个参数放在单独的引号中。

```kdl
    // 使用 brightnessctl 的亮度键映射示例。
    // 也可使用普通 spawn 并放多个参数（避免经过 "sh"），
    // 但需要手动将每个参数放在单独引号中。
    XF86MonBrightnessUp allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "+10%"; }
    XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "10%-"; }
```

### 11.7 桌面概览与关闭窗口

```kdl
    // 打开/关闭概览：工作区和窗口的缩放视图。
    // 也可将鼠标移至左上角热区，或在触摸板上四指上滑。
    Mod+O repeat=false { toggle-overview; }

    Mod+Q repeat=false { close-window; }
```

### 11.8 窗口焦点

```kdl
    Mod+Left  { focus-column-left; }
    Mod+Down  { focus-window-down; }
    Mod+Up    { focus-window-up; }
    Mod+Right { focus-column-right; }
    Mod+H     { focus-column-left; }
    Mod+J     { focus-window-down; }
    Mod+K     { focus-window-up; }
    Mod+L     { focus-column-right; }
```

### 11.9 移动窗口/列

```kdl
    Mod+Ctrl+Left  { move-column-left; }
    Mod+Ctrl+Down  { move-window-down; }
    Mod+Ctrl+Up    { move-window-up; }
    Mod+Ctrl+Right { move-column-right; }
    Mod+Ctrl+H     { move-column-left; }
    Mod+Ctrl+J     { move-window-down; }
    Mod+Ctrl+K     { move-window-up; }
    Mod+Ctrl+L     { move-column-right; }
```

跨工作区变体（已注释）：

```kdl
    // 替代命令：当到达列中第一个或最后一个窗口时跨工作区移动。
    // Mod+J     { focus-window-or-workspace-down; }
    // Mod+K     { focus-window-or-workspace-up; }
    // Mod+Ctrl+J     { move-window-down-or-to-workspace-down; }
    // Mod+Ctrl+K     { move-window-up-or-to-workspace-up; }
```

### 11.10 首尾列

```kdl
    Mod+Home { focus-column-first; }
    Mod+End  { focus-column-last; }
    Mod+Ctrl+Home { move-column-to-first; }
    Mod+Ctrl+End  { move-column-to-last; }
```

### 11.11 显示器焦点

```kdl
    Mod+Shift+Left  { focus-monitor-left; }
    Mod+Shift+Down  { focus-monitor-down; }
    Mod+Shift+Up    { focus-monitor-up; }
    Mod+Shift+Right { focus-monitor-right; }
    Mod+Shift+H     { focus-monitor-left; }
    Mod+Shift+J     { focus-monitor-down; }
    Mod+Shift+K     { focus-monitor-up; }
    Mod+Shift+L     { focus-monitor-right; }
```

### 11.12 移动列至其他显示器

```kdl
    Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
    Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
    Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
    Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
    Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
    Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
    Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
    Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }
```

其他变体（已注释）：

```kdl
    // 或者，也有仅移动单个窗口的命令：
    // Mod+Shift+Ctrl+Left  { move-window-to-monitor-left; }
    // ...
    // 也可以将整个工作区移动到其他显示器：
    // Mod+Shift+Ctrl+Left  { move-workspace-to-monitor-left; }
    // ...
```

### 11.13 工作区导航

```kdl
    Mod+Page_Down      { focus-workspace-down; }
    Mod+Page_Up        { focus-workspace-up; }
    Mod+U              { focus-workspace-down; }
    Mod+I              { focus-workspace-up; }
    Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
    Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
    Mod+Ctrl+U         { move-column-to-workspace-down; }
    Mod+Ctrl+I         { move-column-to-workspace-up; }
```

仅移动单个窗口的变体（已注释）：

```kdl
    // 或者，也有仅移动单个窗口的命令：
    // Mod+Ctrl+Page_Down { move-window-to-workspace-down; }
    // ...
```

移动工作区：

```kdl
    Mod+Shift+Page_Down { move-workspace-down; }
    Mod+Shift+Page_Up   { move-workspace-up; }
    Mod+Shift+U         { move-workspace-down; }
    Mod+Shift+I         { move-workspace-up; }
```

### 11.14 鼠标滚轮绑定

滚轮绑定会基于 `natural-scroll` 设置改变方向。可使用 `cooldown-ms` 属性防止快速滚动。

```kdl
    // 可以使用以下语法绑定鼠标滚轮滚动。
    // 这些绑定将根据 natural-scroll 设置改变方向。
    //
    // 为了防止快速滚动工作区，可以使用 cooldown-ms 属性。
    // 绑定将被限制在此值。可为任何绑定设置冷却时间，但对滚轮最有用。
    Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
    Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
    Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
    Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

    Mod+WheelScrollRight      { focus-column-right; }
    Mod+WheelScrollLeft       { focus-column-left; }
    Mod+Ctrl+WheelScrollRight { move-column-right; }
    Mod+Ctrl+WheelScrollLeft  { move-column-left; }

    // 通常在应用中按住 Shift 滚动上下相当于水平滚动；这些绑定模拟了这点。
    Mod+Shift+WheelScrollDown      { focus-column-right; }
    Mod+Shift+WheelScrollUp        { focus-column-left; }
    Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
    Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }
```

触摸板滚动绑定（已注释示例）：

```kdl
    // 同样，可以绑定触摸板滚动"刻度"。
    // 触摸板滚动是连续的，因此这些绑定被分割为离散间隔。
    // 这些绑定也受触摸板 natural-scroll 影响，因此这些示例绑定是"反向"的，
    // 因为默认情况下我们为触摸板启用了 natural-scroll。
    // Mod+TouchpadScrollDown { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.02+"; }
    // Mod+TouchpadScrollUp   { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.02-"; }
```

### 11.15 按索引切换工作区

注意：niri 是一个动态工作区系统，因此这些命令是"尽力而为"的。尝试引用大于当前工作区数量的索引将改为引用最底部（空）工作区。例如，有 2 个工作区 + 1 个空，索引 3、4、5 等都将引用第 3 个工作区。

```kdl
    // 可以通过索引引用工作区。但请注意，niri 是动态工作区系统，
    // 因此这些命令是"尽力而为"的。
    // 尝试引用大于当前工作区数量的索引将改为引用最底部（空）工作区。
    //
    // 例如，有 2 个工作区 + 1 个空，索引 3、4、5 等都将引用第 3 个工作区。
    Mod+1 { focus-workspace 1; }
    Mod+2 { focus-workspace 2; }
    Mod+3 { focus-workspace 3; }
    Mod+4 { focus-workspace 4; }
    Mod+5 { focus-workspace 5; }
    Mod+6 { focus-workspace 6; }
    Mod+7 { focus-workspace 7; }
    Mod+8 { focus-workspace 8; }
    Mod+9 { focus-workspace 9; }
    Mod+Ctrl+1 { move-column-to-workspace 1; }
    Mod+Ctrl+2 { move-column-to-workspace 2; }
    Mod+Ctrl+3 { move-column-to-workspace 3; }
    Mod+Ctrl+4 { move-column-to-workspace 4; }
    Mod+Ctrl+5 { move-column-to-workspace 5; }
    Mod+Ctrl+6 { move-column-to-workspace 6; }
    Mod+Ctrl+7 { move-column-to-workspace 7; }
    Mod+Ctrl+8 { move-column-to-workspace 8; }
    Mod+Ctrl+9 { move-column-to-workspace 9; }
```

仅移动单个窗口的变体（已注释）：

```kdl
    // 或者，有仅移动单个窗口的命令：
    // Mod+Ctrl+1 { move-window-to-workspace 1; }
```

上一个工作区（已注释）：

```kdl
    // 在当前和前一个工作区之间切换焦点。
    // Mod+Tab { focus-workspace-previous; }
```

### 11.16 窗口列操作 — 合并与分离

```kdl
    // 以下绑定将聚焦的窗口移入或移出列。
    // 如果窗口单独存在，则将其吸入旁边的列。
    // 如果窗口已在列中，则将其弹出。
    Mod+BracketLeft  { consume-or-expel-window-left; }
    Mod+BracketRight { consume-or-expel-window-right; }

    // 从右侧吸入一个窗口到聚焦列的底部。
    Mod+Comma  { consume-window-into-column; }
    // 将聚焦列底部的窗口弹出到右侧。
    Mod+Period { expel-window-from-column; }
```

### 11.17 列宽度控制

```kdl
    // 在 preset-column-widths 设置的宽度之间循环。
    Mod+R { switch-preset-column-width; }
    // 也支持反向循环。
    Mod+Shift+R { switch-preset-column-width-back; }

    Mod+Ctrl+Shift+R { switch-preset-window-height; }
    Mod+Ctrl+R { reset-window-height; }

    Mod+F { maximize-column; }
    Mod+Shift+F { fullscreen-window; }

    // maximize-column 会在窗口周围保留间距和边框，
    // 而 maximize-window-to-edges 则不会：窗口扩展到屏幕边缘。
    // 此绑定对应正常的窗口最大化，例如双击标题栏。
    Mod+M { maximize-window-to-edges; }
    Mod+N {spawn-sh "pkill waybar || waybar";}

    // 将聚焦列扩展到未被其他完全可见列占用的空间。
    // 使列"填满剩余空间"。
    Mod+Ctrl+F { expand-column-to-available-width; }

    Mod+C { center-column; }

    // 将所有完全可见的列在屏幕上居中。
    Mod+Ctrl+C { center-visible-columns; }
```

### 11.18 精确宽度/高度调整

```kdl
    // 更精细的宽度调整。
    // 此命令还支持：
    // * 设置像素宽度："1000"
    // * 按像素调整："-5" 或 "+5"
    // * 设置屏幕宽度百分比："25%"
    // * 按屏幕宽度百分比调整："-10%" 或 "+10%"
    // 像素尺寸使用逻辑（缩放）像素。即在 scale 2.0 的输出上，
    // set-column-width "100" 将使列占据 200 个物理屏幕像素。
    Mod+Minus { set-column-width "-10%"; }
    Mod+Equal { set-column-width "+10%"; }

    // 在与其他窗口同列时进行更精细的高度调整。
    Mod+Shift+Minus { set-window-height "-10%"; }
    Mod+Shift+Equal { set-window-height "+10%"; }
```

### 11.19 浮动与标签页

```kdl
    // 在浮动和平铺布局之间移动聚焦窗口。
    Mod+V       { spawn-sh "kitty --single-instance --class cliphist-tui -e cliphist-tui"; }
    Mod+Shift+V { switch-focus-between-floating-and-tiling; }

    // 切换标签页式列显示模式。
    // 此列中的窗口将显示为垂直标签，而不是彼此堆叠。
    Mod+W { toggle-column-tabbed-display; }
```

### 11.20 布局切换（已注释）

```kdl
    // 切换布局的操作。
    // 注意：如果取消注释这些，请确保上面的 xkb 选项中未配置匹配的布局切换快捷键。
    // 两者同时使用会破坏切换，因为按下快捷键时会切换两次（一次由 xkb，一次由 niri）。
    // Mod+Space       { switch-layout "next"; }
    // Mod+Shift+Space { switch-layout "prev"; }
```

### 11.21 截图

```kdl
    Print { screenshot; }
    Ctrl+Print { screenshot-screen; }
    Alt+Print { screenshot-window; }
```

### 11.22 快捷键抑制

```kdl
    // 远程桌面客户端和软件 KVM 切换器等应用可能会请求 niri
    // 停止处理此处定义的键盘快捷键，以便将按键原样转发到远程机器。
    // 最好绑定一个逃生口来切换抑制器，这样有 bug 的应用就不会挟持会话。
    //
    // allow-inhibiting=false 属性也可应用于其他绑定，确保 niri 始终处理它们，
    // 即使抑制器处于活动状态。
    Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
```

### 11.23 退出与关闭显示器

```kdl
    // quit 操作会显示确认对话框，防止意外退出。
    Mod+Shift+E { quit; }
    Ctrl+Alt+Delete { quit; }

    // 关闭显示器电源。要重新打开，执行任何输入（如移动鼠标或按任意键）。
    Mod+Shift+P { power-off-monitors; }
}
```

---

## 12. 环境变量 — `environment {}`

```kdl
environment {
    XMODIFIERS "@im=fcitx"
}
```

---

## 13. 内置启动程序

默认配置中包含的启动程序（非注释）：

```kdl
spawn-at-startup "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
spawn-at-startup "fcitx5"
spawn-at-startup "wl-paste" "--watch" "cliphist" "store"
spawn-at-startup "waypaper" "--restore"
```

---

## 14. 自定义窗口规则 (cliphist-tui)

```kdl
window-rule{
    // 用 app-id 指定窗口
 match app-id="cliphist-tui"
    // 默认长宽

  default-column-width { fixed 625; }
    default-window-height { fixed 700; }
    // 以浮动模式打开
    open-floating true
    // 默认打开位置，x 和 y 是偏移量。
    // 此处示例：在顶部中心打开，y 轴向下 18 个逻辑像素
    default-floating-position x=0 y=18 relative-to="top"
}
```

---

> 本文档基于 niri 默认配置生成，翻译并整理了所有注释供参考。
> 实际自定义配置请参见 `config.kdl` 及 `cfg/` 目录下的各模块文件。
