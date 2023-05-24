import os
import re
import socket
import subprocess

from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from typing import List
from libqtile.utils import guess_terminal


mod = "mod4"
terminal = guess_terminal()

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(),
        desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(),
        desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(),
        desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(),
        desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(),
        desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod, "shift"], "r", lazy.spawncmd(),
        desc="Spawn a command using a prompt widget"),
    Key([mod], "r", lazy.spawn('rofi -show run'),
        desc="Spawn a command using a prompt widget"),
]

##### GROUPS #####
group_names = [
    ("DEV", {'layout': 'monadtall'}),
    ("PYCHARM", {'layout': 'monadtall'}),
    ("TTY", {'layout': 'monadtall'}),
    ("TTY2", {'layout': 'monadtall'}),
    ("CHAT", {'layout': 'monadtall'}),
    ("MUS", {'layout': 'monadtall'}),
    ("VID", {'layout': 'monadtall'}),
    ("ZOOM", {'layout': 'floating'}),
]

groups = [Group(name, **kwargs) for name, kwargs in group_names]


for i, (name, kwargs) in enumerate(group_names, 1):
    keys.append(Key([mod], str(i), lazy.group[name].toscreen()))
    keys.append(Key([mod, "shift"], str(i), lazy.window.togroup(name)))

layout_theme = {
    "border_width": 2,
    "margin": 6,
    "border_focus": "e1axff",
    "border_normal": "1d2330",
}

layouts = [
    layout.MonadTall(**layout_theme),
    layout.Max(**layout_theme),
    layout.Tile(shift_windows=True, **layout_theme),
    layout.Stack(num_stacks=2),
    layout.TreeTab(
        font="Ubuntu",
        fontsize=10,
        sections=["FIRST", "SECOND"],
        section_fontsize=11,
        bg_color="141414",
        active_bg="90C435",
        active_fg="000000",
        inactive_bg="384323",
        inactive_fg="a0a0a0",
        padding_y=5,
        section_top=10,
        panel_width=320,
    ),
    layout.Floating(num_stacks=2),
]

##### COLORS #####
colors = [["#282a36", "#282a36"],  # panel background
          ["#434758", "#434758"],  # background for current screen tab
          ["#ffffff", "#ffffff"],  # font color for group names
          ["#ff5555", "#ff5555"],  # border line color for current tab
          ["#8d62a9", "#8d62a9"],  # border line color for other tab and odd widgets
          ["#668bd7", "#668bd7"],  # color for the even widgets
          ["#e1acff", "#e1acff"]]  # window name

# layouts = [
#     layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
#     layout.Max(),
# Try more layouts by unleashing below layouts.
# layout.Stack(num_stacks=2),
# layout.Bsp(),
# layout.Matrix(),
# layout.MonadTall(),
# layout.MonadWide(),
# layout.RatioTile(),
# layout.Tile(),
# layout.TreeTab(),
# layout.VerticalTile(),
# layout.Zoomy(),
# ]

prompt = "{}@{}: ".format(os.environ["USER"], socket.gethostname())

widget_defaults = dict(
    font="Ubuntu Mono",
    fontsize=12,
    padding=2,
    background=colors[0],
)
extension_defaults = widget_defaults.copy()

# screens = [
#     Screen(
#         top=bar.Bar(
#             [
#                 widget.CurrentLayout(),
#                 widget.GroupBox(),
#                 widget.Prompt(),
#                 widget.WindowName(),
#                 widget.Chord(
#                     chords_colors={
#                         "launch": ("#ff0000", "#ffffff"),
#                     },
#                     name_transform=lambda name: name.upper(),
#                 ),
#                 widget.TextBox("default config", name="default"),
#                 widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
#                 # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
#                 # widget.StatusNotifier(),
#                 widget.Systray(),
#                 widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
#                 widget.QuickExit(),
#             ],
#             24,
#             # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
#             # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
#         ),
#     ),
# ]

####### Widgets #######


def init_widgets_list():
    return [
        widget.Sep(
            linewidth=0,
            padding=6,
            foreground=colors[2],
            background=colors[2]
        ),
        widget.GroupBox(
            font="Ubuntu Bold",
            fontsize=9,
            margin_y=3,
            margin_x=0,
            padding_y=5,
            padding_x=5,
            borderwidth=3,
            active=colors[2],
            inactive=colors[2],
            rounded=False,
            highlight_color=colors[1],
            highlight_method="line",
            this_current_screen_border=colors[3],
            this_screen_border=colors[4],
            other_current_screen_border=colors[0],
            other_screen_border=colors[0],
            foreground=colors[2],
            background=colors[0]
        ),
        widget.Prompt(
            prompt=prompt,
            font="Ubuntu Mono",
            padding=10,
            foreground=colors[3],
            background=colors[0]
        ),
        widget.Sep(
            linewidth=0,
            padding=40,
            foreground=colors[2],
            background=colors[0]
        ),
        widget.WindowName(
            foreground=colors[6],
            background=colors[0],
            padding=0
        ),
        widget.TextBox(
            text=" 🌡",
            padding=2,
            foreground=colors[2],
            background=colors[0],
            fontsize=11
        ),
        widget.ThermalSensor(
            foreground=colors[2],
            background=colors[0],
            padding=5
        ),
        widget.TextBox(
            text=" ⟳",
            padding=2,
            foreground=colors[4],
            background=colors[0],
            fontsize=14
        ),
        widget.TextBox(
            text="Updates",
            padding=5,
            foreground=colors[4],
            background=colors[0]
        ),
        widget.TextBox(
            text=" 🖬",
            foreground=colors[3],
            background=colors[0],
            padding=0,
            fontsize=14
        ),
        widget.Memory(
            background=colors[0],
            foreground=colors[5],
            padding=5
        ),
        widget.Net(
            interface="wlp4s0",
            format='{down} ↓↑ {up}',
            foreground=colors[5],
            background=colors[0],
            padding=5
        ),
        widget.TextBox(
            foreground=colors[3],
            text=" Vol:",
            background=colors[0],
            padding=0
        ),
        widget.Volume(
            foreground=colors[3],
            background=colors[0],
            padding=5
        ),
        widget.CurrentLayout(
            foreground=colors[4],
            background=colors[0],
            padding=5
        ),
        widget.Clock(
            foreground=colors[2],
            background=colors[0],
            format="%A, %B %d  [ %H:%M ]"
        ),
        widget.Sep(
            linewidth=0,
            padding=10,
            foreground=colors[2],
            background=colors[0]
        ),
        widget.Systray(
            background=colors[0],
            padding=5
        ),
    ]


def init_widgets_screen1():
    return init_widgets_list()


def init_widgets_screen2():
    return init_widgets_list()


def init_screens():
    return [
        Screen(top=bar.Bar(widgets=init_widgets_screen1(), opacity=0.95, size=20))
    ]


if __name__ in ["config", "__main__"]:
    screens = init_screens()
    widget_list = init_widgets_list()

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False

# floating_layout = layout.Floating(
#     float_rules=[
#         # Run the utility of `xprop` to see the wm class and name of an X client.
#         *layout.Floating.default_float_rules,
#         Match(wm_class="confirmreset"),  # gitk
#         Match(wm_class="makebranch"),  # gitk
#         Match(wm_class="maketag"),  # gitk
#         Match(wm_class="ssh-askpass"),  # ssh-askpass
#         Match(title="branchdialog"),  # gitk
#         Match(title="pinentry"),  # GPG key password entry
#     ]
# )
floating_layout = layout.Floating(float_rules=[
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
])

auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"