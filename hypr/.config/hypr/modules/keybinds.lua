--------------------------------------------------------------------------------
-- KEYBINDINGS CONFIGURATION
-- Documentation: https://wiki.hypr.land/Configuring/Basics/Binds/
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- 1. PROGRAMS & VARIABLES
--------------------------------------------------------------------------------
local terminal    = "kitty"
local fileManager = "dolphin"
local menu        = "pkill rofi || rofi -show drun"
local ide         = "code"
local browser1    = "vivaldi --profile-directory=Default"
local browser2    = "brave"

-- Macropad device options
local macropad_opts = {
    device = {
        inclusive = true,
        list = { "hs6209-2.4g-wireless-receiver" },
    },
}

--------------------------------------------------------------------------------
-- 2. HELPER FUNCTIONS
--------------------------------------------------------------------------------
-- Smart window switcher / launcher:
-- If app is not running -> launch it (optionally on target workspace).
-- If running -> focus it or cycle through open instances.
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
            window = "address:" .. matches[1].address,
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

    -- Cycle to next instance
    local next = (current % #matches) + 1

    hl.dispatch(hl.dsp.focus({
        window = "address:" .. matches[next].address,
    }))
end

--------------------------------------------------------------------------------
-- 3. APPLICATION LAUNCHERS & MENUS
--------------------------------------------------------------------------------
-- Launchers
hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd(menu), { release = true }) -- App launcher (Rofi)
hl.bind("SUPER + TAB",     hl.dsp.exec_cmd("rofi -show window"))       -- Window switcher (Rofi)
hl.bind("SUPER + T",       hl.dsp.exec_cmd(terminal))                  -- Terminal (Kitty)
hl.bind("SUPER + E",       hl.dsp.exec_cmd(fileManager))               -- File Manager (Dolphin)

-- Apps (Smart Focus / Cycle / Launch)
hl.bind("SUPER + A", function()
    launch("vivaldi-stable", { command = browser1 })
end)
hl.bind("SUPER + SHIFT + A", hl.dsp.exec_cmd(browser1))
hl.bind("SUPER + D", function()
    launch("code-oss")
end)
hl.bind("SUPER + G", function()
    launch("brave-browser", { command = browser2 })
end)

hl.bind("SUPER + SHIFT + A", hl.dsp.exec_cmd(browser2))

hl.bind("SUPER + O", function()
    launch("md.obsidian.Obsidian", { command = "obsidian" })
end)

--------------------------------------------------------------------------------
-- 4. WINDOW MANAGEMENT
--------------------------------------------------------------------------------
-- Window Actions
hl.bind("SUPER + B",         hl.dsp.layout("togglesplit"))                   -- Dwindle split toggle
hl.bind("SUPER + F",         hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind("SUPER + P",         hl.dsp.window.pseudo())                         -- Dwindle pseudo-tiling
hl.bind("SUPER + Q",         hl.dsp.window.close())
hl.bind("SUPER + SHIFT + F", hl.dsp.window.float())

-- Optional: Fullscreen state toggle
-- hl.bind("SUPER + SHIFT + F", function()
--     hl.dsp.window.fullscreen_state({
--         internal = 0,
--         client = 2,
--         action = "toggle",
--     })
-- end)

-- Move Focus (Arrow Keys)
hl.bind("SUPER + left",  hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up",    hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down",  hl.dsp.focus({ direction = "down" }))

-- Move Focus (Vim Keys)
hl.bind("SUPER + h", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + j", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + k", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + l", hl.dsp.focus({ direction = "right" }))

-- Move Active Window (Arrow Keys)
hl.bind("SUPER + SHIFT + LEFT",  hl.dsp.window.move({ monitor = "HDMI-A-1" }))
hl.bind("SUPER + SHIFT + RIGHT", hl.dsp.window.move({ monitor = "eDP-1" }))

-- Move Active Window (Vim Keys)
hl.bind("SUPER + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + SHIFT + j", hl.dsp.window.move({ direction = "down" }))
hl.bind("SUPER + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + SHIFT + l", hl.dsp.window.move({ direction = "right" }))

-- Mouse & Modifier Window Drag / Resize
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind("SUPER + CONTROL_L", hl.dsp.window.drag(),   { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("SUPER + ALT_L",     hl.dsp.window.resize(), { mouse = true })

--------------------------------------------------------------------------------
-- 5. WORKSPACES & SCRATCHPAD
--------------------------------------------------------------------------------
-- Switch Workspaces (SUPER + 1..0) & Move Window to Workspace (SUPER + SHIFT + 1..0)
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind("SUPER + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = true }))
    -- hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Cycle Through Workspaces
hl.bind("ALT + TAB",          hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Special Workspace (Scratchpad)
hl.bind("SUPER + S",         hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))

--------------------------------------------------------------------------------
-- 6. UTILITIES, TOOLS & SCRIPTS
--------------------------------------------------------------------------------
-- Clipboard Manager
hl.bind("SUPER + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))

-- Notifications (SwayNC)
hl.bind("SUPER + N",         hl.dsp.exec_cmd("swaync-client -t"))
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd("swaync-client -R && swaync-client -rs"))

-- Screenshot
hl.bind("SUPER + C", hl.dsp.exec_cmd("hyprshot -m output"))

-- Status Bar (Waybar Toggle / Reload)
hl.bind("SUPER + W", hl.dsp.exec_cmd("pkill -x waybar || waybar >/dev/null 2>&1 &"))

-- Wallpaper Switcher
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("/home/shamil/.config/hypr/scripts/random-wallpaper-switcher.sh"))

-- Waybinder Snippets
hl.bind("SUPER + R", hl.dsp.exec_cmd("/home/shamil/dotfiles/hypr/.config/hypr/scripts/waybinder.sh"))

-- Scrcpy Mobile App Launcher
hl.bind("SUPER + Z", hl.dsp.exec_cmd("~/.config/hypr/scripts/scrcpy-tcpip-app-launcher.sh"))

--------------------------------------------------------------------------------
-- 7. HARDWARE CONTROLS (AUDIO, BRIGHTNESS, MONITORS)
--------------------------------------------------------------------------------
-- Audio Volume & Mute (wpctl)
hl.bind("XF86AudioRaiseVolume",   hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("CONTROL + bracketright", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",   hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("CONTROL + bracketleft",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",          hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",       hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })

-- Screen Brightness (brightnessctl)
hl.bind("XF86MonBrightnessUp",            hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("CONTROL + SHIFT + bracketright", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",          hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("CONTROL + SHIFT + bracketleft",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Display Power Management (DPMS)
hl.bind("SUPER + F11", hl.dsp.dpms({ action = "toggle", monitor = "HDMI-A-1" }))
hl.bind("SUPER + F12", hl.dsp.dpms({ action = "toggle", monitor = "eDP-1" }))

--------------------------------------------------------------------------------
-- 8. MEDIA PLAYBACK (PLAYERCTL)
--------------------------------------------------------------------------------
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

--------------------------------------------------------------------------------
-- 9. SYSTEM & POWER CONTROLS
--------------------------------------------------------------------------------
hl.bind("SUPER + HOME",              hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind("CONTROL + SHIFT + ALT + D", hl.dsp.exec_cmd("shutdown now"))
hl.bind("CONTROL + SHIFT + ALT + F", hl.dsp.exec_cmd("reboot"))

--------------------------------------------------------------------------------
-- 10. MACROPAD BINDINGS (hs6209-2.4g-wireless-receiver)
--------------------------------------------------------------------------------
-- Spotify Controls & Shortcuts
hl.bind("KP_Multiply", function()
    launch("Spotify", { command = "spotify", workspace = 10 })
end, macropad_opts)

hl.bind("KP_Divide", function()
    hl.dispatch(hl.dsp.send_shortcut({
        mods = "CONTROL_L",
        key = "L",
        window = "class:Spotify",
    }))
    hl.dispatch(hl.dsp.focus({
        window = "class:Spotify",
    }))
end, macropad_opts)

hl.bind("KP_INSERT", function()
    hl.dispatch(hl.dsp.focus({
        window = "class:Spotify",
    }))
    hl.dispatch(hl.dsp.send_shortcut({
        mods = "CONTROL_L",
        key = "L",
        window = "class:Spotify",
    }))
end, macropad_opts)

hl.bind("KP_Home",    hl.dsp.send_shortcut({ mods = "CONTROL_L", key = "Left",  window = "class:Spotify" }), macropad_opts)
hl.bind("KP_Up",      hl.dsp.send_shortcut({ mods = "",          key = "Space", window = "class:Spotify" }), macropad_opts)
hl.bind("KP_Page_Up", hl.dsp.send_shortcut({ mods = "CONTROL_L", key = "Right", window = "class:Spotify" }), macropad_opts)
hl.bind("KP_Add",     hl.dsp.send_shortcut({ mods = "CONTROL_L", key = "Right", window = "class:Spotify" }), macropad_opts)

-- Media Controls (Playerctl)
hl.bind("KP_BEGIN",  hl.dsp.exec_cmd("playerctl play-pause"), macropad_opts)
hl.bind("KP_Enter",  hl.dsp.exec_cmd("playerctl play-pause"), macropad_opts)
hl.bind("KP_LEFT",   hl.dsp.exec_cmd("playerctl previous"),   macropad_opts)
hl.bind("KP_RIGHT",  hl.dsp.exec_cmd("playerctl next"),       macropad_opts)
hl.bind("Backspace", hl.dsp.exec_cmd("playerctl play-pause"), macropad_opts)

-- Volume Controls (wpctl)
hl.bind("KP_Page_Down", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),  macropad_opts)
hl.bind("KP_Down",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), macropad_opts)
hl.bind("KP_END",       hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),  macropad_opts)

-- Custom Scripts & Shortcuts
hl.bind("KP_Subtract", function()
    hl.dispatch(hl.dsp.focus({
        window = "class:vivaldi-stable",
    }))
    hl.dispatch(hl.dsp.exec_cmd(
        "python /mnt/d/Programs/Random-Youtube-Video-from-Playlist/Random-Youtube-Video-from-Playlist.py https://www.youtube.com/playlist?list=PLb-MR2Hfk3tmamG_oQKvYK--4uZ0ULfHn"
    ))
end, macropad_opts)