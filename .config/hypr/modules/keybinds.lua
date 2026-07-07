---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal    = "kitty"
local fileManager = "dolphin"
local menu        = "pkill rofi || rofi -show drun"
local ide         = "code"
local browser1     = 'zen-browser'
local browser2     = 'zen-browser -P "Leisure"'
-----------------------

---------------------
---- KEYBINDINGS ----
---------------------
-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more


hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + ESCAPE", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind("SUPER + R", hl.dsp.exec_cmd(menu), { release = true })
hl.bind("SUPER + P", hl.dsp.window.pseudo())
hl.bind("SUPER + B", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + F", hl.dsp.window.fullscreen())
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
hl.bind("SUPER + X", function()
    local ws = hl.get_active_workspace()
    for _, monitor in ipairs(hl.get_monitors()) do
        hl.notification.create({ 
            text = "Monitors: " .. monitor.name, 
            timeout = 3000, 
            icon = "info" 
        })
    end
    -- if ws ~= nil then
    --     local ws_name = ws.name
    --     -- Send a notification showing the active workspace name
    --     hl.notification.create({ 
    --         text = "Current Workspace: " .. ws_name, 
    --         timeout = 3000, 
    --         icon = "info" 
    --     })
    -- end
end)

-- Example special workspace (scratchpad)
hl.bind("SUPER + S",         hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false}))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER + mouse_up",   hl.dsp.focus({ workspace = "e+1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
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
hl.bind("SUPER + SHIFT + A", hl.dsp.exec_cmd(browser1))
hl.bind("SUPER + SHIFT + G", hl.dsp.exec_cmd(browser2))
hl.bind("SUPER + O", hl.dsp.exec_cmd("obsidian"))
hl.bind("SUPER + D", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + E", hl.dsp.exec_cmd(fileManager))

hl.bind("SUPER + Z", hl.dsp.exec_cmd("~/.config/hypr/scripts/scrcpy-tcpip-app-launcher.sh"))
hl.bind("SUPER + W", hl.dsp.exec_cmd("pkill -x waybar || waybar >/dev/null 2>&1 &"))
hl.bind("SUPER + C", hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind("SUPER + A", hl.dsp.exec_cmd("swaync-client -t"))

hl.bind("CONTROL + SHIFT + ALT + D", hl.dsp.exec_cmd("shutdown now"))
hl.bind("CONTROL + SHIFT + ALT + F", hl.dsp.exec_cmd("reboot"))


hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd("swaync-client -R && swaync-client -rs"))
hl.bind("SUPER + V", hl.dsp.exec_cmd("cliphist list | wofi --dmenu --pre-display-cmd \"echo \'%s\' | cut -f 2\" | cliphist decode | wl-copy"))
hl.bind("SUPER + TAB", hl.dsp.exec_cmd(menu .. " window"))
hl.bind("ALT + Tab", function()
    hl.dispatch(hl.dsp.window.cycle_next())    -- Change focus to another window
    hl.dispatch(hl.dsp.window.bring_to_top()) -- Bring it to the top
end)