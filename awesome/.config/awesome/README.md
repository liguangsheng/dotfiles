# Awesome WM 配置

基于 **Awesome v4.3** 的窗口管理器配置。

## 目录结构

```
.
├── rc.lua                  # 主配置：快捷键、窗口规则、信号处理
├── rc_widget.lua           # 状态栏组件：系统监控、时钟、布局等
├── autorun.sh              # 自启动脚本
├── bin/                    # 组件数据脚本
│   ├── cpu.sh              # CPU 使用率
│   ├── disk.sh             # 磁盘使用率
│   ├── meminfo.sh          # 内存信息（输出 Lua table）
│   ├── traffic.sh          # 网络流量
│   └── uptime.sh           # 系统运行时长
├── tokyo_night/            # Tokyo Night 主题（当前使用）
├── catppuccin_mocha/       # Catppuccin Mocha 主题
├── papercolor/             # PaperColor 主题
└── icons/                  # 图标资源（布局、标签、标题栏）
```

## 主要特性

- **主题**：内置三套主题，默认 Tokyo Night，每套含配色、壁纸和标题栏图标
- **九字真言标签**："临 兵 斗 者 皆 阵 列 在 前"
- **状态栏组件**：内核版本、运行时长、CPU、内存、磁盘、网络流量、时钟
- **GLib 2.80+ 兼容**：polyfill 处理 `Gio.UnixInputStream` 迁移至 `GioUnix` 命名空间的问题
- **Rofi 集成**：动态主题化的应用启动器，替代默认 menubar
- **VMware 支持**：自动隐藏 vmware-user 拖拽窗口

## 快捷键（Mod = Super）

| 快捷键 | 功能 |
|---|---|
| `Mod+j/k` | 切换焦点 |
| `Mod+Shift+j/k` | 交换窗口位置 |
| `Mod+f` | 全屏 |
| `Mod+Shift+c` | 关闭窗口 |
| `Mod+Space` | 切换布局 |
| `Mod+p` | Rofi 启动器 |
| `Mod+r` | 命令提示符 |
| `Mod+1-9` | 切换标签 |
| `Mod+Shift+1-9` | 移动窗口到标签 |

## 布局

tile、tile.bottom、max、corner.nw、floating

## 字体

- 主字体：Maple Mono NF CN / MonaspiceKr Nerd Font
- 图标字体：Symbols Nerd Font Mono
- 标签字体：AR PL UKai CN
