------------------
---- MONITORS ---- (BATTERY OPTIMISED)
------------------
-- Drop-in replacement for the monitor section.
-- eDP-1 and HDMI-A-1 are capped at 60 Hz (down from 144 Hz).
-- This is one of the most impactful battery savings on a laptop —
-- halving the refresh rate roughly halves GPU rendering workload.
--
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
        -- External monitor at 60 Hz
        hl.monitor({ output = "HDMI-A-1", mode = "2560x1440@@143.91", position = "0x0",    scale = 1 })
        hl.monitor({ output = "eDP-1",    mode = "1920x1080@60", position = "2560x0", scale = 1.2 })
    else
        -- Built-in panel at 60 Hz
        hl.monitor({ output = "eDP-1",    mode = "1920x1080@60", position = "0x0",    scale = 1 })
    end
end

apply_monitor_config()

hl.on("monitor.added",   apply_monitor_config)
hl.on("monitor.removed", apply_monitor_config)

hl.timer(apply_monitor_config, {
    timeout = 1000,
    type    = "oneshot"
})
