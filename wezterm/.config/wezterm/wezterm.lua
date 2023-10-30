local wezterm = require 'wezterm'
local config = {}

function scheme_for_appearance(appearance)
    if appearance:find "Dark" then
        return "Catppuccin Mocha"
    else
        return "Catppuccin Latte"
    end
end

config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())
config.font_size = 9.0
config.font = wezterm.font_with_fallback {
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
