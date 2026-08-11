------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hdmi_connected = false

local function is_hdmi_connected()
    for _, monitor in ipairs(hl.get_monitors()) do
        if monitor.name == "HDMI-A-1" then
            return true
        end
    end
    return false
end

local function apply_monitor_config()
    hdmi_connected = is_hdmi_connected()

    if hdmi_connected then
        hl.monitor({ output = "HDMI-A-1", mode = "2560x1440@143.91", position = "0x0", scale = 1 })
        hl.monitor({ output = "eDP-1", mode = "1920x1080@144.42", position = "2560x0", scale = 1.2})
        -- hl.monitor({ output = "HDMI-A-1", disabled = true})
    else
        -- hl.monitor({ output = "HDMI-A-1", mode = "2560x1440@143.91", position = "0x0", scale = 1.25 })
        hl.monitor({ output = "eDP-1", mode = "1920x1080@144.42", position = "2560x0", scale = 1})
    end
end

-- Apply immediately
apply_monitor_config()

-- Reapply when monitors are connected/disconnected
hl.on("monitor.added", apply_monitor_config)
hl.on("monitor.removed", apply_monitor_config)

-- Delayed reapply to catch monitors that initialize after config parsing
-- Runs before workspace rules timer (1500ms) to ensure hdmi_connected is current
hl.timer(apply_monitor_config, {
    timeout = 1000,
    type = "oneshot"
})