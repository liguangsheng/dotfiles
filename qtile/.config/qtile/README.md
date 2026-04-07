# Qtile 配置

基于 **Qtile 0.35.0** 的平铺窗口管理器配置。

## 目录结构

```
.
├── config.py               # 主配置：快捷键、分组、布局、屏幕、浮动规则
├── config_widget.py        # 自定义组件：Kernel、Memory、Uptime、DiskUsage 等
├── config_utils.py         # 工具函数：壁纸管理、颜色处理、大小格式化
└── themes/                 # 主题
    ├── catppuccin_mocha.py  # Catppuccin Mocha 主题（当前使用）
    ├── nord.py              # Nord 主题
    ├── catppuccin_bg.png    # Catppuccin 壁纸
    └── nord_bg.png          # Nord 壁纸
```

## 主要特性

- **主题**：Catppuccin Mocha（默认）和 Nord 两套主题，含配色与壁纸
- **自定义组件**：内核版本、运行时长、CPU、内存、磁盘、Qtile 自身内存占用
- **Rofi 集成**：动态主题化的应用启动器和窗口切换器
- **壁纸系统**：支持从 API 在线获取壁纸，缓存至 `~/.cache/qtile/wallpapers/`
- **wmname**：设为 `LG3D` 以兼容 Java 应用

## 快捷键（Mod = Super）

| 快捷键 | 功能 |
|---|---|
| `Mod+h/j/k/l` | Vim 风格窗口导航 |
| `Mod+Shift+h/j/k/l` | 移动/交换窗口 |
| `Mod+i / Mod+Shift+i` | 放大/缩小窗口 |
| `Mod+m` | 最大化 |
| `Mod+Shift+m` | 全屏 |
| `Mod+Shift+c` | 关闭窗口 |
| `Mod+f` | 切换浮动 |
| `Mod+Shift+Return` | 打开终端 |
| `Mod+Shift+Tab` | 切换布局 |
| `Mod+p` | Rofi 启动器 |
| `Mod+Shift+p` | Rofi run |
| `Mod+w` | Rofi 窗口切换 |
| `Mod+Ctrl+p` | 更换壁纸 |
| `Mod+1-9` | 切换工作区 |
| `Mod+Shift+1-9` | 移动窗口到工作区 |

## 布局

MonadTall、MonadWide、Max

## 工作区

9 个工作区（1-9），部分预设默认布局：

- 工作区 1：max（Emacs）
- 工作区 3：max
- 工作区 4：monadwide

## 终端

按优先级依次检测：wezterm、kitty、alacritty、st、uxterm、urxvt
