---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal    = "kitty"
local fileManager = "dolphin"
-- local menu        = "pkill rofi || rofi -show drun"
local menu        = "pkill rofi || rofi -show drun"
local ide         = "code"
local browser1     = 'vivaldi'
local browser2     = 'zen-browser -P "Leisure"'
-----------------------

---------------------
---- KEYBINDINGS ----
---------------------
-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more


hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + HOME", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd(menu), { release = true })
hl.bind("SUPER + P", hl.dsp.window.pseudo())
hl.bind("SUPER + B", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + F", hl.dsp.window.fullscreen({mode = "fullscreen"}))
hl.bind("SUPER + SHIFT + F", function()
    hl.dsp.window.fullscreen_state({
        internal = 0,
        client = 2,
        action = "toggle",
    })
end)
hl.bind("SUPER + SHIFT + F", hl.dsp.window.float())

-- Move focus with mainMod
hl.bind("SUPER + left",  hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up",    hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down",  hl.dsp.focus({ direction = "down" }))

hl.bind("SUPER + h",  hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + l", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + j",    hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + k",  hl.dsp.focus({ direction = "down" }))

hl.bind("SUPER + SHIFT + h",  hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
hl.bind("SUPER + SHIFT + j",    hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + SHIFT + k",  hl.dsp.window.move({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind("SUPER + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind("SUPER + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i, follow = true }))
    -- hl.bind("SUPER + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Retrieve the workspace name and use it in a keybinding
-- hl.bind("SUPER + X", function()    
--     hl.dispatch(hl.dsp.exec_cmd(
--     [[notify-send "Active Window" "$(hyprctl activewindow -j | jq -r '.title')"]]
-- ))
    -- local ws = hl.get_active_workspace()
    -- for _, monitor in ipairs(hl.get_monitors()) do
    --     hl.notification.create({ 
    --         text = "Monitors: " .. monitor.name, 
    --         timeout = 3000, 
    --         icon = "info" 
    --     })
    -- end

    -- if ws ~= nil then
    --     local ws_name = ws.name
    --     -- Send a notification showing the active workspace namewofi
    --     hl.notification.create({ 
    --         text = "Current Workspace: " .. ws_name, 
    --         timeout = 3000, 
    --         icon = "info" 
    --     })
    -- end
-- end)

-- Example special workspace (scratchpad)
hl.bind("SUPER + S",         hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false}))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind("SUPER + CONTROL_L", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("SUPER + ALT_L", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("CONTROL + bracketright", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("CONTROL + bracketleft", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("CONTROL + SHIFT + bracketright",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })
hl.bind("CONTROL + SHIFT + bracketleft",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
-----------------------------

-- My Binds
-- Applications
-- hl.bind("SUPER + SHIFT + A", hl.dsp.exec_cmd(browser1))
hl.bind("SUPER + SHIFT + G", hl.dsp.exec_cmd(browser2))
hl.bind("SUPER + E", hl.dsp.exec_cmd(fileManager))

hl.bind("SUPER + Z", hl.dsp.exec_cmd("~/.config/hypr/scripts/scrcpy-tcpip-app-launcher.sh"))
hl.bind("SUPER + W", hl.dsp.exec_cmd("pkill -x waybar || waybar >/dev/null 2>&1 &"))
hl.bind("SUPER + C", hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind("SUPER + N", hl.dsp.exec_cmd("swaync-client -t"))

hl.bind("CONTROL + SHIFT + ALT + D", hl.dsp.exec_cmd("shutdown now"))
hl.bind("CONTROL + SHIFT + ALT + F", hl.dsp.exec_cmd("reboot"))

hl.bind("SUPER + SHIFT + RIGHT", hl.dsp.window.move({ monitor = "eDP-1"}))
hl.bind("SUPER + SHIFT + LEFT", hl.dsp.window.move({ monitor = "HDMI-A-1"}))



hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd("swaync-client -R && swaync-client -rs"))
-- hl.bind("SUPER + V", hl.dsp.exec_cmd("cliphist list | wofi --dmenu --pre-display-cmd \"echo \'%s\' | cut -f 2\" | cliphist decode | wl-copy"))
hl.bind("SUPER + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))
hl.bind("ALT + TAB", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + TAB", hl.dsp.exec_cmd("rofi -show window"))



-- hl.bind("SUPER + TAB", function()
--     hl.dispatch(hl.dsp.window.cycle_next())    -- Change focus to another window
--     hl.dispatch(hl.dsp.window.bring_to_top()) -- Bring it to the top
-- end)

---------------------
--- MY FUNCTIONS ----
---------------------

local function launch(class, opts)
    opts = opts or {}

    local command = opts.command
    local workspace = opts.workspace

    local windows = hl.get_windows()
    local active = hl.get_active_window()

    local matches = {}

    for _, w in ipairs(windows) do
        if w.class == class then
            table.insert(matches, w)
        end
    end

    -- Launch if none exist
    if #matches == 0 then
        local launch_command = command or class

        hl.dispatch(hl.dsp.exec_cmd(
            launch_command,
            { workspace = workspace }
        ))

        return
    end

    -- Focus if there's only one
    if #matches == 1 then
        hl.dispatch(hl.dsp.focus({
            window = "address:" .. matches[1].address
        }))
        return
    end

    -- Find the active matching window
    local current = 0

    if active then
        for i, w in ipairs(matches) do
            if w.address == active.address then
                current = i
                break
            end
        end
    end

    -- Cycle to next
    local next = (current % #matches) + 1

    hl.dispatch(hl.dsp.focus({
        window = "address:" .. matches[next].address
    }))
end

-- hl.bind("SUPER + T", function()
--     launch("kitty", "kitty")
-- end)

hl.bind("SUPER + T", hl.dsp.exec_cmd(terminal))

hl.bind("SUPER + O", function()
    launch("md.obsidian.Obsidian", { command = "obsidian" })
end)

hl.bind("SUPER + D", function()
    launch("code-oss")
end)

hl.bind("SUPER + S", function()
    launch("vivaldi-stable")
end)

hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("/home/shamil/.config/hypr/scripts/random-wallpaper-switcher.sh"))


hl.bind("SUPER + SHIFT + A", hl.dsp.exec_cmd(browser1))

hl.bind("SUPER + F11", hl.dsp.dpms({ action = "toggle", monitor = "HDMI-A-1" }))
hl.bind("SUPER + F12", hl.dsp.dpms({ action = "toggle", monitor = "eDP-1" }))

----------------------------
----- MacroPad Binds -------
----------------------------

-- Numpad /
hl.bind("KP_Divide", 
    function()
        hl.dispatch(hl.dsp.send_shortcut({
            mods = "CONTROL_L",
            key = "L",
            window = "class:Spotify"
        }))

        hl.dispatch(hl.dsp.focus({
            window = "class:Spotify"
        }))
    end, {
    device = {
        inclusive = true,
        list = { "hs6209-2.4g-wireless-receiver" }
    }
})

-- Numpad *
hl.bind("KP_Multiply", 
    function()
        launch("Spotify", {command = "spotify", workspace = 10})
    end, {
    device = {
        inclusive = true,
        list = { "hs6209-2.4g-wireless-receiver" }
    }
})

-- Numpad -
hl.bind("KP_Subtract",
    function()
        hl.dispatch(hl.dsp.focus({
            window = "class:vivaldi-stable"
        }))

        hl.dispatch(hl.dsp.exec_cmd(
            "python /mnt/d/Programs/Python-Scripts/Random-Youtube-Video-from-Playlist.py https://www.youtube.com/playlist?list=PLb-MR2Hfk3tmamG_oQKvYK--4uZ0ULfHn"
        ))
    end, {
        device = {
        inclusive = true,
        list = { "hs6209-2.4g-wireless-receiver" }
    }
})

-- Numpad +
hl.bind("KP_Add", 
    hl.dsp.send_shortcut({ mods = "CONTROL_L", key = "Right", window = "class:Spotify" }), {
    device = {
        inclusive = true,
        list = { "hs6209-2.4g-wireless-receiver" }
    }
})

-- Numpad 9
hl.bind("KP_Page_Up ", 
    hl.dsp.send_shortcut({ mods = "CONTROL_L", key = "Right", window = "class:Spotify" }), {
    device = {
        inclusive = true,
        list = { "hs6209-2.4g-wireless-receiver" }
    }
})

-- Numpad 8
hl.bind("KP_Up", 
    hl.dsp.send_shortcut({ mods = "", key = "Space", window = "class:Spotify" }), {
    device = {
        inclusive = true,
        list = { "hs6209-2.4g-wireless-receiver" }
    }
})

-- Numpad 7
hl.bind("KP_Home", 
    hl.dsp.send_shortcut({ mods = "CONTROL_L", key = "Left", window = "class:Spotify" }), {
    device = {
        inclusive = true,
        list = { "hs6209-2.4g-wireless-receiver" }
    }
})

-- Numpad 6
hl.bind("KP_RIGHT", 
    hl.dsp.exec_cmd("playerctl next"), {
    device = {
        inclusive = true,
        list = { "hs6209-2.4g-wireless-receiver" }
    }
})

-- Numpad 5
hl.bind("KP_BEGIN", 
    hl.dsp.exec_cmd("playerctl play-pause"), {
    device = {
        inclusive = true,
        list = { "hs6209-2.4g-wireless-receiver" }
    }
})


-- Numpad 4
hl.bind("KP_LEFT", 
    hl.dsp.exec_cmd("playerctl previous"), {
    device = {
        inclusive = true,
        list = { "hs6209-2.4g-wireless-receiver" }
    }
})

-- Numpad 3
hl.bind("KP_Page_Down", 
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), {
    device = {
        inclusive = true,
        list = { "hs6209-2.4g-wireless-receiver" }
    }
})

-- Numpad 2
hl.bind("KP_Down", 
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), {
    device = {
        inclusive = true,
        list = { "hs6209-2.4g-wireless-receiver" }
    }
})

-- Numpad 1
hl.bind("KP_END", 
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), {
    device = {
        inclusive = true,
        list = { "hs6209-2.4g-wireless-receiver" }
    }
})

-- Numpad 0
hl.bind("KP_INSERT", function()
    hl.dispatch(hl.dsp.focus({
        window = "class:Spotify"
    }))

    hl.dispatch(hl.dsp.send_shortcut({
        mods = "CONTROL_L",
        key = "L",
        window = "class:Spotify"
    }))
end, {
    device = {
        inclusive = true,
        list = { "hs6209-2.4g-wireless-receiver" }
    }
})

hl.bind("Backspace", 
    hl.dsp.exec_cmd("playerctl play-pause"), {
    device = {
        inclusive = true,
        list = { "hs6209-2.4g-wireless-receiver" }
    }
})

hl.bind("KP_Enter", 
    hl.dsp.exec_cmd("playerctl play-pause"), {
    device = {
        inclusive = true,
        list = { "hs6209-2.4g-wireless-receiver" }
    }
})


---------------------------------------------------------------------------------------------------------------------------


hl.bind("CONTROL_L + bracketleft", 
    hl.dsp.send_shortcut({ mods = "", key = "backslash"}), {
    device = {
        inclusive = true,
        list = { "hs6209-2.4g-wireless-receiver" }
    }
})
