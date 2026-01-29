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
import re
import sys
import logging

from libqtile import bar, layout, widget, qtile
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile.log_utils import logger


logger.setLevel(logging.INFO)

sys.path.append(os.getcwd() + ".config/qtile")
import config_widget
import config_utils

MOD = "mod4"
SHIFT = "shift"
CONTROL = "control"
TERMINAL = guess_terminal(
    [
        "wezterm",
        "kitty",
        "alacritty",
        "st",
        "uxterm",
        "urxvt",
    ]
)


from themes.catppuccin_mocha import *

ROFI_THEME_ARGS = f"-theme-str '*{{primary: {COLOR_PRIM};background: {COLOR_BG};}}'"
CMD_ROFI_DRUN = f"rofi -show drun {ROFI_THEME_ARGS}"
CMD_ROFI_RUN = f"rofi -show run {ROFI_THEME_ARGS}"
CMD_ROFI_WINDOWCD = f"rofi -show windowcd {ROFI_THEME_ARGS}"

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
    Key([MOD], "m", lazy.window.toggle_maximize()),
    Key([MOD, SHIFT], "space", lazy.layout.flip()),
    Key([MOD], "Return", lazy.layout.swap_main()),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([MOD, SHIFT], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key(
        [MOD, SHIFT], "l", lazy.layout.shuffle_right(), desc="Move window to the right"
    ),
    Key([MOD, SHIFT], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([MOD, SHIFT], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key(
        [MOD, SHIFT], "Left", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [MOD, SHIFT],
        "Right",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([MOD, SHIFT], "Down", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([MOD, SHIFT], "Up", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([MOD, SHIFT], "m", lazy.window.toggle_fullscreen()),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([MOD, CONTROL], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([MOD, CONTROL], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([MOD, CONTROL], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([MOD, CONTROL], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key(
        [MOD, CONTROL], "Left", lazy.layout.grow_left(), desc="Grow window to the left"
    ),
    Key(
        [MOD, CONTROL],
        "Right",
        lazy.layout.grow_right(),
        desc="Grow window to the right",
    ),
    Key([MOD, CONTROL], "Up", lazy.layout.grow_down(), desc="Grow window down"),
    Key([MOD, CONTROL], "Down", lazy.layout.grow_up(), desc="Grow window up"),
    # Toggle between different layouts as defined below
    Key([MOD, SHIFT], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([MOD, SHIFT], "c", lazy.window.kill(), desc="Kill focused window"),
    Key([MOD], "f", lazy.window.toggle_floating()),
    # qtile keys
    Key([MOD, CONTROL], "r", lazy.restart(), desc="Restart Qtile"),
    Key([MOD, CONTROL], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([MOD, CONTROL], "p", lazy.function(config_utils.change_wallpaper)),
    # applications
    Key([MOD, SHIFT], "Return", lazy.spawn(TERMINAL), desc="Launch terminal"),
    Key(
        [MOD, SHIFT], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"
    ),
    Key([MOD], "p", lazy.spawn(CMD_ROFI_DRUN), desc="Rofi drun"),
    Key([MOD, SHIFT], "p", lazy.spawn(CMD_ROFI_RUN), desc="Rofi run"),
    Key([MOD], "w", lazy.spawn(CMD_ROFI_WINDOWCD), desc="Rofi window cd"),
]


groups = [
    Group(
        str(1),
        label="",
        matches=[Match(wm_class=re.compile(r"^(Emacs)$"))],
        layout="max",
    ),
    Group(str(2), label="", layout="monadtall"),
    Group(str(3), label="", layout="max"),
    Group(str(4), label="", layout="monadwide"),
    Group(str(5), label=""),
    Group(str(6), label=""),
    Group(str(7), label=""),
    Group(str(8), label=""),
    Group(str(9), label=""),
]

for i, group in enumerate(groups, start=1):
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [MOD],
                str(i),
                lazy.group[group.name].toscreen(),
                desc="Switch to group {}".format(group.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [MOD, "shift"],
                str(i),
                lazy.window.togroup(group.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(group.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

layouts = [
    layout.MonadTall(
        margin=6,
        border_width=2,
        ratio=0.5,
        border_normal=COLOR_BORDER_NORMAL,
        border_focus=COLOR_PRIM,
        max_ratio=0.9,
        min_ratio=1.0,
    ),
    layout.MonadWide(
        margin=6,
        border_width=2,
        ratio=0.5,
        border_normal=COLOR_BORDER_NORMAL,
        border_focus=COLOR_PRIM,
        max_ratio=0.9,
        min_ratio=1.0,
    ),
    layout.Max(
        margin=6,
        border_width=2,
        border_normal=COLOR_BORDER_NORMAL,
        border_focus=COLOR_PRIM,
        only_foused=True,
    ),
    # Try more layouts by unleashing below layouts.
    # layout.Columns(border_focus_stack=[COLOR_PRIM, COLOR_PRIM_ALT], border_width=3),
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
    text="|",
    background=COLOR_BG,
    foreground=COLOR_BAR_SEP,
    padding=0,
    fontsize=9,
    font=ICON_FONT,
)

left_widgets = [
    # widget.Image(
    #     filename = "~/.config/qtile/themes/launcher.png",
    #     margin = 5,
    # ),
    widget.Sep(linewidth=0, padding=6, foreground=COLOR_FG, background=COLOR_BG),
    widget.GroupBox(
        fontsize=10,
        margin_y=3,
        margin_x=8,
        padding_y=5,
        padding_x=1,
        borderwidth=1,
        rounded=False,
        highlight_method="text",
        urgent_alert_method="text",
        background=COLOR_BG,
        foreground=COLOR_FG,
        inactive=COLOR_FG_ALT,
        active=COLOR_FG,
        highlight_color="#fbbc26",
        this_current_screen_border=COLOR_PRIM,  # 当前屏幕，当前焦点工作区
        this_screen_border=COLOR_BG,  # 当前屏幕，非焦点工作区
        other_current_screen_border=COLOR_PRIM,  # 非当前屏幕，当前焦点工作区
        other_screen_border=COLOR_BG,  # 非当前屏幕，非焦点工作区
        urgent_border=COLOR_URGENT,
        urgent_text=COLOR_URGENT,
    ),
    barsep,
    # widget.CurrentLayoutIcon(padding=3, scale=0.6, foreground=COLOR_FG, background=COLOR_BG),
    widget.CurrentLayout(),
    barsep,
    # widget.WindowName(padding=5, foreground=COLOR_PRIM),
    widget.TaskList(
        border=COLOR_PRIM,
        foreground=COLOR_BG,
        highlight_method="block",
        rounded=True,
        title_width_method="uniform",
        unfocused_border=COLOR_PRIM_ALT,
        urgent_alert_method="border",
        urgert_border=COLOR_URGENT,
        window_name_location=True,
    ),
]

right_widgets = [
    config_widget.Kernel(format=" {release}"),
    barsep,
    config_widget.Uptime(prefix="󰅕"),
    barsep,
    # widget.Net(format=' {down}|{up}'),
    # barsep,
    widget.CPU(threshold=90, format=" {load_percent:.0f}%"),
    barsep,
    config_widget.Memory(format="  {MemPercent:.0f}%({MemUsedHuman})"),
    barsep,
    config_widget.DiskUsage(format=" {r:.0f}%({uh})", visible_on_warn=False),
    barsep,
    config_widget.QtileMemory(),
    barsep,
    widget.Clock(format=" %Y-%m-%d %H:%M:%S %A", font=ICON_FONT),
    barsep,
    widget.Systray(padding=2, icon_size=14),
    widget.Sep(linewidth=0, padding=6, foreground=COLOR_FG, background=COLOR_BG),
]

screens = [
    Screen(
        wallpaper=WALLPAPER,
        wallpaper_mode="fill",
        top=bar.Bar(
            left_widgets + right_widgets,
            background=COLOR_BG,
            foreground=COLOR_FG,
            size=32,
            margin=[0, 0, 0, 0],
            opacity=1,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [MOD],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [MOD], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([MOD], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = False
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(wm_class="fcitx5-config-qt"),
        Match(wm_type="dnd"),  # 针对 _NET_WM_WINDOW_TYPE_DND
    ],
    max_border_width=2,
    border_focus="#94E2D5",
)
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
