#!/bin/bash

# 定义主题目录和配置文件路径
THEME_DIR="$HOME/.config/alacritty/themes"
CONFIG_FILE="$HOME/.config/alacritty/alacritty.toml"

# 使用 ls 和 fzf 选择主题文件
SELECTED_THEME=$(ls "$THEME_DIR" | fzf)

# 检查用户是否选择了主题
if [[ -n "$SELECTED_THEME" ]]; then
  # 使用 sed 替换 alacritty.toml 中的主题文件名
  sed -i "s#\(import = \[\"$THEME_DIR/\)[^/]*\.toml\"\]#\1$SELECTED_THEME\"]#g" "$CONFIG_FILE"
  echo "主题已更新为: $SELECTED_THEME"
else
  echo "未选择主题，操作已取消。"
fi

