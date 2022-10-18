----------------------------
-- Catppuccin Mocha Theme --
----------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_configuration_dir() .. "icons"
local theme = {}

function darken_color(color, factor)
    local r, g, b = tonumber(color:sub(2, 3), 16), tonumber(color:sub(4, 5), 16), tonumber(color:sub(6, 7), 16)
    r = math.floor(r * factor)
    g = math.floor(g * factor)
    b = math.floor(b * factor)
    return string.format("#%02x%02x%02x", r, g, b)
end

theme.font           = "Maple Mono NF CN 9"
theme.wallpaper      = gfs.get_configuration_dir() .. "catppuccin_mocha/wallpaper.png"

theme.primary        = "#eba0ac"
-- theme.primary = "#4f7da4" -- 蓝黑
-- theme.primary = "#458586" -- green
-- theme.primary = "#61afef" -- blue
-- theme.primary = "#C46B77" -- red
-- theme.primary = "#d9a977" -- yellow
theme.darken_primary = darken_color(theme.primary, 0.7)

theme.bg_normal      = "#1e1e2e"
theme.bg_widget      = theme.bg_normal
theme.bg_focus       = theme.primary
theme.bg_urgent      = "#ff0000"
theme.bg_minimize    = "#444444"
theme.bg_systray     = theme.bg_normal

theme.fg_normal      = "#cdd6f4"
theme.fg_widget      = theme.fg_normal
theme.fg_focus       = "#ffffff"
theme.fg_urgent      = "#ffffff"
theme.fg_minimize    = "#ffffff"


theme.bar_height           = 28
theme.useless_gap          = dpi(2)

-- window border
theme.border_width         = dpi(2)
theme.border_focus         = theme.primary
-- theme.border_normal = theme.darken_primary
-- theme.border_marked = "#91231c"
theme.border_normal        = '#44475a'
theme.border_marked        = '#bd93f9'

-- taglist
theme.taglist_font         = "AR PL UKai CN 10"
theme.taglist_fg_focus     = theme.bg_normal

-- systray
theme.systray_icon_spacing = 2
theme.bg_systray           = theme.bg_normal

-- tasklist
theme.tasklist_bg_normal   = "#6c7086"
theme.tasklist_fg_normal   = theme.bg_normal
theme.tasklist_fg_focus    = theme.bg_normal


-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
local taglist_square_size                       = dpi(4)
theme.taglist_squares_sel                       = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel                     = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon                         = themes_path .. "/submenu.png"
theme.menu_height                               = dpi(15)
theme.menu_width                                = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal              = themes_path .. "/titlebar/close_normal.png"
theme.titlebar_close_button_focus               = themes_path .. "/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal           = themes_path .. "/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus            = themes_path .. "/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive     = themes_path .. "/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = themes_path .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = themes_path .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active        = themes_path .. "/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive    = themes_path .. "/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = themes_path .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = themes_path .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active       = themes_path .. "/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive  = themes_path .. "/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = themes_path .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = themes_path .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active     = themes_path .. "/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path .. "/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = themes_path .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = themes_path .. "/titlebar/maximized_focus_active.png"

-- You can use your own layout icons like this:
theme.layout_fairh                              = themes_path .. "/layouts/fairhw.png"
theme.layout_fairv                              = themes_path .. "/layouts/fairvw.png"
theme.layout_floating                           = themes_path .. "/layouts/floatingw.png"
theme.layout_magnifier                          = themes_path .. "/layouts/magnifierw.png"
theme.layout_max                                = themes_path .. "/layouts/maxw.png"
theme.layout_fullscreen                         = themes_path .. "/layouts/fullscreenw.png"
theme.layout_tilebottom                         = themes_path .. "/layouts/tilebottomw.png"
theme.layout_tileleft                           = themes_path .. "/layouts/tileleftw.png"
theme.layout_tile                               = themes_path .. "/layouts/tilew.png"
theme.layout_tiletop                            = themes_path .. "/layouts/tiletopw.png"
theme.layout_spiral                             = themes_path .. "/layouts/spiralw.png"
theme.layout_dwindle                            = themes_path .. "/layouts/dwindlew.png"
theme.layout_cornernw                           = themes_path .. "/layouts/cornernww.png"
theme.layout_cornerne                           = themes_path .. "/layouts/cornernew.png"
theme.layout_cornersw                           = themes_path .. "/layouts/cornersww.png"
theme.layout_cornerse                           = themes_path .. "/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon                              = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme                                = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
