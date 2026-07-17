---@module 'hl'

hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@60",
    position = "auto",
    scale    = 1,
})

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
    mirror = "eDP-1",
})

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
end)

-- Fixes seatd error
-- TODO: what error?
hl.env("LIBSEAT_BACKEND", "logind")

hl.config({
    input = {
        kb_layout = "us,ru",
        kb_options = "grp:alt_shift_toggle",
        touchpad = {
            disable_while_typing = false,
            natural_scroll = true,
        },
        sensitivity = 0,
    },
})

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,

        layout = "dwindle",
    },
})

hl.config({
    decoration = {
        rounding = 0,

        blur = {
            enabled = true,
            new_optimizations = true,
            ignore_opacity = true,
        },

        shadow = {
            enabled = false,
        },
    },
})

hl.curve("b1", { type = "bezier", points = { { 0.05, 0.85 }, { 0.03, 0.97 } } })
hl.curve("b2", { type = "bezier", points = { { 0.07, 0.88 }, { 0.04, 0.99 } } })
hl.curve("b3", { type = "bezier", points = { { 1, 1 }, { 1, 1 } } })
hl.curve("b4", { type = "bezier", points = { { 0.05, 0.80 }, { 0.10, 0.97 } } })
hl.curve("b5", { type = "bezier", points = { { 0.05, 0.82 }, { 0, 1 } } })
hl.curve("b6", { type = "bezier", points = { { 0.20, 0 }, { 0.82, 0.10 } } })
hl.curve("b7", { type = "bezier", points = { { 0, 0.48 }, { 0.38, 1 } } })
hl.animation({ leaf = "border", enabled = true, speed = 1.6, bezier = "b3", })
hl.animation({ leaf = "borderangle", enabled = true, speed = 82, bezier = "b3", style = "loop", })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3.2, bezier = "b2", style = "slide", })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2.8, bezier = "b7", })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3.0, bezier = "b1", style = "slide", })
hl.animation({ leaf = "fade", enabled = true, speed = 1.8, bezier = "b4", })
hl.animation({ leaf = "layersIn", enabled = true, speed = 1.8, bezier = "b5", style = "slide", })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "b6", })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.6, bezier = "b5", })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.8, bezier = "b6", })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.0, bezier = "b5", style = "slide", })
hl.config({ animations = { enabled = true, }, })

hl.config({
    dwindle = {
        preserve_split = true,
    },
})

hl.config({
    misc = {
        disable_hyprland_logo = true,
        disable_autoreload = true,

        enable_swallow = true,
        swallow_regex = "^(foot)$",
    },
})

hl.config({
    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },
})

hl.bind("SUPER + SHIFT + RETURN", hl.dsp.exec_cmd("foot"))
hl.bind("SUPER + SHIFT + F",      hl.dsp.exec_cmd(os.getenv("BROWSER")))
hl.bind("SUPER + SHIFT + E",      hl.dsp.exec_cmd("foot nvim")) -- E stands for editor

hl.bind("SUPER + SHIFT + R",        hl.dsp.exec_cmd("reaper"))
hl.bind("SUPER + SHIFT + CTRL + R", hl.dsp.exec_cmd("renoise"))

hl.bind("SUPER + Tab", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"))

hl.bind("SUPER + O", hl.dsp.exec_cmd("rofi -show run"))

hl.bind("SUPER + L", hl.dsp.exec_cmd("lock"))

hl.bind("SUPER + SHIFT + C", hl.dsp.window.close())
hl.bind("SUPER + SHIFT + Q", hl.dsp.exit())

hl.bind("SUPER + V", hl.dsp.window.float())
hl.bind("SUPER + C", hl.dsp.window.center())

-- Move focus with SUPER + arrow keys
hl.bind("SUPER + left",  hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up",    hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down",  hl.dsp.focus({ direction = "down" }))

-- Move window with mainMod + SHIFT + arrow keys
hl.bind("SUPER + SHIFT + left",  hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + SHIFT + up",    hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + down",  hl.dsp.window.move({ direction = "d" }))

-- Switch workspaces with mainMod + [0-5]
hl.bind("SUPER + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind("SUPER + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind("SUPER + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind("SUPER + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind("SUPER + 5", hl.dsp.focus({ workspace = 5 }))

-- Move active window to a workspace with mainMod + SHIFT + [0-5]
hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind("SUPER + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Toggle swallowing
hl.bind("SUPER + S", hl.dsp.window.toggle_swallow())

hl.bind("F11", hl.dsp.window.fullscreen())

-- Screenshots
hl.bind("Print",         hl.dsp.exec_cmd("screenshot-select"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("screenshot-full"))

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("amixer -q sset Master 1%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("amixer -q sset Master 1%-"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("amixer -q sset Master toggle"))

-- Disable animations for wallpaper window
hl.layer_rule({
    match = { namespace = "wallpaper" },
    no_anim = true,
})

-- Style popups
hl.window_rule({
    match = { tag = "popup", },
    center = true,
    stay_focused = true,
    dim_around = true,
    no_anim = true,
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    match = {
        class = "^$", title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})

-- XWayland gtk file picker fix
hl.window_rule({
    match = {
        class = "^Xdg-desktop-portal-gtk$",
        xwayland = true,
    },
    decorate = false,
})
