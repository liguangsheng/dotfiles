local wezterm = require 'wezterm'
local config = {}

config.color_scheme = 'Nord (Gogh)'
config.font_size = 9.0
config.font = wezterm.font_with_fallback {
    {
        family = 'MonaspiceXe Nerd Font',
        weight = 'Medium',
    },
    {
        family = 'JetBrains Mono Nerd Font',
        weight = 'Medium',
    },
    {
        family = 'FiraCode Nerd Font',
        weight = 'Medium',
    },
    {
        family = 'LXGW WenKai Mono',
        scale = 1.2,
    },
    {
        family = 'AR PL UKai CN',
        scale = 1.2,
    },
    "WenQuanYi Micro Hei Mono",
    "WenQuanYi Zen Hei Mono",
    "LXGW WenKai Mono",
    "Noto Color Emoji",
}

config.enable_scroll_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 1.0
config.check_for_updates = false
config.check_for_updates_interval_seconds = 86400

return config
