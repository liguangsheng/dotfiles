# -*- coding: utf-8 -*-
# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik # Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


from typing import List  # noqa: F401
import os
import sys
import logging

from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile.log_utils import logger


logger.setLevel(logging.INFO)

sys.path.append(os.getcwd()+".config/qtile")
import config_widget
import config_utils

MOD      = "mod4"
SHIFT    = "shift"
CONTROL  = "control"
TERMINAL = guess_terminal([
    'alacritty',
    'wezterm',
    'st',
    'kitty',
    'uxterm',
    'urxvt',
])

WALLPAPER = os.path.expanduser("~/.config/qtile/wallpaper.jpg")

WIDGET_FONT = "JetBrainsMono Nerd Font, AR PL UKai CN"
ICON_FONT = "JetBrainsMono Nerd Font"

COLOR_PRIM    = "#4f7da4"
COLOR_URGENT  = "#ff5555"
COLOR_BG      = "#282c34"
COLOR_BG_ALT  = "#222222"
COLOR_FG      = "#f8f8f8"
COLOR_FG_ALT  = "#666666"

ROFI_DRUN_CMD = f"rofi -show drun -theme-str '*{{primary: {COLOR_PRIM};background: {COLOR_BG};}}'"
ROFI_RUN_CMD  = f"rofi -show run  -theme-str '*{{primary: {COLOR_PRIM};background: {COLOR_BG};}}'"

keys = [
    # Switch between windows
    Key([MOD], "h", lazy.layout.left()),
    Key([MOD], "l", lazy.layout.right()),
    Key([MOD], "j", lazy.layout.down()),
    Key([MOD], "k", lazy.layout.up()),
    Key([MOD, SHIFT], "h", lazy.layout.swap_left()),
    Key([MOD, SHIFT], "l", lazy.layout.swap_right()),
    Key([MOD, SHIFT], "j", lazy.layout.shuffle_down()),
    Key([MOD, SHIFT], "k", lazy.layout.shuffle_up()),
    Key([MOD], "i", lazy.layout.grow()),
    Key([MOD, SHIFT], "i", lazy.layout.shrink()),
    Key([MOD], "n", lazy.layout.normalize()),
    Key([MOD], "m", lazy.layout.maximize()),
    Key([MOD, SHIFT], "space", lazy.layout.flip()),
    Key([MOD], "Return", lazy.layout.swap_main()),

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([MOD, SHIFT], "h", lazy.layout.shuffle_left(),
        desc="Move window to the left"),
    Key([MOD, SHIFT], "l", lazy.layout.shuffle_right(),
        desc="Move window to the right"),
    Key([MOD, SHIFT], "j", lazy.layout.shuffle_down(),
        desc="Move window down"),
    Key([MOD, SHIFT], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([MOD, SHIFT], "Left", lazy.layout.shuffle_left(),
        desc="Move window to the left"),
    Key([MOD, SHIFT], "Right", lazy.layout.shuffle_right(),
        desc="Move window to the right"),
    Key([MOD, SHIFT], "Down", lazy.layout.shuffle_down(),
        desc="Move window down"),
    Key([MOD, SHIFT], "Up", lazy.layout.shuffle_up(), desc="Move window up"),

    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([MOD, CONTROL], "h", lazy.layout.grow_left(),
        desc="Grow window to the left"),
    Key([MOD, CONTROL], "l", lazy.layout.grow_right(),
        desc="Grow window to the right"),
    Key([MOD, CONTROL], "j", lazy.layout.grow_down(),
        desc="Grow window down"),
    Key([MOD, CONTROL], "k", lazy.layout.grow_up(), desc="Grow window up"),

    Key([MOD, CONTROL], "Left", lazy.layout.grow_left(),
        desc="Grow window to the left"),
    Key([MOD, CONTROL], "Right", lazy.layout.grow_right(),
        desc="Grow window to the right"),
    Key([MOD, CONTROL], "Up", lazy.layout.grow_down(),
        desc="Grow window down"),
    Key([MOD, CONTROL], "Down", lazy.layout.grow_up(), desc="Grow window up"),

    # Toggle between different layouts as defined below
    Key([MOD, SHIFT], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([MOD, SHIFT], "c", lazy.window.kill(), desc="Kill focused window"),
    Key([MOD], "w", lazy.spawn("rofi -show windowcd"), desc="Rofi window cd"),
    Key([MOD], "f", lazy.window.toggle_floating()),

    # qtile keys
    Key([MOD, CONTROL] , "r", lazy.restart(), desc="Restart Qtile"),
    Key([MOD, CONTROL], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([MOD, CONTROL], "p", lazy.function(config_utils.change_wallpaper)),

    # applications
    Key([MOD, SHIFT], "Return", lazy.spawn(TERMINAL), desc="Launch terminal"),
    Key([MOD, SHIFT], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([MOD], "p", lazy.spawn(ROFI_DRUN_CMD), desc="Rofi drun"),
    Key([MOD, SHIFT], "p", lazy.spawn(ROFI_RUN_CMD), desc="Rofi run"),
]


groups = [Group(str(i), label='') for i in range(1,10)]

for i, group in enumerate(groups, start=1):
    keys.extend([
        # mod1 + letter of group = switch to group
        Key([MOD], str(i), lazy.group[group.name].toscreen(),
            desc="Switch to group {}".format(group.name)),

        # mod1 + shift + letter of group = switch to & move focused window to group
        Key([MOD, "shift"], str(i), lazy.window.togroup(group.name, switch_group=True),
            desc="Switch to & move focused window to group {}".format(group.name)),
        # Or, use below if you prefer not to switch to that group.
        # # mod1 + shift + letter of group = move focused window to group
        # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
        #     desc="move focused window to group {}".format(i.name)),
    ])

layouts = [
    layout.MonadTall(
        margin=6,
        border_width=3,
        ratio=0.5,
        border_normal=COLOR_BG,
        border_focus=COLOR_PRIM,
    ),
    layout.Max(
        margin=6,
        birder_width=2,
        border_normal=COLOR_BG_ALT,
        border_focus=COLOR_PRIM,
    ),
    # Try more layouts by unleashing below layouts.
    # layout.Columns(border_focus_stack=['#d75f5f', '#8f3d3d'], border_width=4),
    # layout.Stack(num_stacks=2),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font=WIDGET_FONT,
    fontsize=12,
    padding=5,
    background=COLOR_BG,
    foreground=COLOR_FG,
)
extension_defaults = widget_defaults.copy()

barsep = widget.TextBox(
    text = '',
    background = COLOR_BG,
    foreground = COLOR_FG_ALT,
    padding = 2,
    fontsize = 18,
    font=ICON_FONT,
)

left_widgets = [
    widget.Sep(
        linewidth = 0,
        padding = 6,
        foreground = COLOR_FG,
        background = COLOR_BG,
    ),
    widget.CurrentLayoutIcon(padding=3, scale=0.6, foreground=COLOR_FG, background=COLOR_BG),
    widget.CurrentLayout(),
    barsep,
    widget.GroupBox(
        fontsize = 12,
        # margin_y = 3,
        # margin_x = 0,
        padding_y = 5,
        padding_x = 1,
        borderwidth = 1,
        rounded = False,
        highlight_method = "text",
        urgent_alert_method = 'text',
        background = COLOR_BG,
        foreground = COLOR_FG,
        inactive = COLOR_FG_ALT,
        active = COLOR_FG,
        highlight_color = COLOR_BG_ALT,
        this_current_screen_border = COLOR_PRIM,  # 当前屏幕，当前焦点工作区
        this_screen_border = COLOR_BG,               # 当前屏幕，非焦点工作区
        other_current_screen_border = COLOR_PRIM, # 非当前屏幕，当前焦点工作区
        other_screen_border = COLOR_BG,              # 非当前屏幕，非焦点工作区
        urgent_border=COLOR_URGENT,
        urgent_text=COLOR_BG,
    ),
    barsep,
    widget.WindowName(padding=5, foreground=COLOR_PRIM),
    # widget.TaskList(),
]

right_widgets = [
    config_widget.Kernel(format=" {release}"),
    barsep,
    config_widget.Uptime(format=' {days}d {hours}h {minutes}m {seconds}s'),
    barsep,
    widget.Net(format=' {down}/{up}'),
    barsep,
    widget.CPU(threshold=90, format=" {load_percent:.0f}%"),
    barsep,
    config_widget.Memory(format=' {MemPercent:.0f}%({MemUsedHuman})'),
    barsep,
    config_widget.DiskUsage(format=' {r:.0f}%({uh})', visible_on_warn=False),
    barsep,
    config_widget.QtileMemory(),
    barsep,
    widget.Clock(format=" %Y-%m-%d %H:%M:%S %A"),
    barsep,
    widget.Systray(padding=2, icon_size=14),
    widget.Sep(
        linewidth = 0,
        padding = 6,
        foreground = COLOR_FG,
        background = COLOR_BG,
    ),
]

screens = [
    Screen(
        wallpaper=WALLPAPER,
        wallpaper_mode="scratch",
        top=bar.Bar(
            left_widgets + right_widgets,
            background=COLOR_BG,
            foreground=COLOR_FG,
            size=28,
            margin=0,
            opacity=0.85,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([MOD], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([MOD], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([MOD], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = False
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
    Match(wm_class='fcitx5-config-qt'),
])
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

