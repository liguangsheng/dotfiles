local wezterm = require 'wezterm'

return {
  color_scheme = 'OneDark (base16)',
  font = wezterm.font_with_fallback {
    {
      family = 'JetBrains Mono Nerd Font',
      weight = 'Medium',
    },
    {
      family = 'FiraCode Nerd Font',
      weight = 'Medium',
    },
    "LXGW WenKai Mono",
    "WenQuanYi Zen Hei Mono",
    "WenQuanYi Micro Hei Mono",
    "AR PL UKai CN",
  },
  font_size = 9.0,
  enable_scroll_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  window_background_opacity = 1.0,
  check_for_updates = false,
  check_for_updates_interval_seconds = 86400,
}
