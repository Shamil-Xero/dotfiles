
--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

hl.window_rule({
  name = "Obsidian-blur",
  match = {
    class = "obsidian"
  },
  opacity = 0.8,
})

hl.window_rule({
  name = "Kitty-blur",
  match = {
    class = "kitty"
  },
  opacity = 0.7,
})

hl.window_rule({
  name = "Vivaldi-blur",
  match = {
    class = "vivaldi-stable"
  },
  opacity = "0.8 override 0.5 override",
})

hl.window_rule({
  name = "YouTube-fullOpacity",
  match = {
    title = ".*YouTube.*"
  },
  opacity = "1 override"
})

-- hl.window_rule({
--   match        = { fullscreen = true },
--   border_color = "rgb(FF0000) rgb(880808)",
-- })

hl.layer_rule({
  name = "Close Rofi when not focus",
  match = {
    namespace = "rofi"
  },
})

local function apply_monitor_rules()
    -- Re-detect monitor state to avoid handler ordering issues
    hdmi_connected = false
    for _, monitor in ipairs(hl.get_monitors()) do
        if monitor.name == "HDMI-A-1" then
            hdmi_connected = true
            break
        end
    end

    -- Apply workspace rules
    for ws = 1, 10 do
        local target_monitor
        local is_default = false

        if hdmi_connected then
            if ws <= 7 then
                target_monitor = "HDMI-A-1"
                is_default = (ws == 1)
                hl.workspace_rule({
                    workspace = tostring(ws),
                    monitor = target_monitor,
                    default = is_default,
                })
            else
                target_monitor = "eDP-1"
                is_default = (ws == 8)
                hl.workspace_rule({
                    workspace = tostring(ws),
                    monitor = target_monitor,
                    default = is_default,
                })
            end
        else
            if ws <= 10 then
                target_monitor = "eDP-1"
                is_default = (ws == 1)
                hl.workspace_rule({
                workspace = tostring(ws),
                monitor = target_monitor,
                default = is_default,
                })
            end
        end
    end
end

-- Apply rules immediately on startup
apply_monitor_rules()

-- Reapply rules whenever monitors are connected or disconnected
hl.on("monitor.added", apply_monitor_rules)
hl.on("monitor.removed", apply_monitor_rules)

-- Delayed reapply to catch monitors that initialize after config parsing
hl.timer(apply_monitor_rules, {
    timeout = 1500,
    type = "oneshot"
})