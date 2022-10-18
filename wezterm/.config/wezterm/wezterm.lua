local wezterm = require 'wezterm'
local act = wezterm.action

local M = {
    enable_scroll_bar = false,

    hide_tab_bar_if_only_one_tab = true,

    window_background_opacity = 1.0,

    check_for_updates = false,

    check_for_updates_interval_seconds = 86400,

    color_scheme = 'Catppuccin Mocha (Gogh)',

    font_size = 9.0,

    font = wezterm.font_with_fallback {
        {
            family = 'Maple Mono NF CN',
            weight = 'Medium',
        },
        {
            family = 'FiraCode Nerd Font',
            weight = 'Medium',
        },
        {
            family = 'JetBrains Mono Nerd Font',
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
}

return M
