------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hdmi_connected = false

for _, monitor in ipairs(hl.get_monitors()) do
    if monitor.name == "HDMI-A-1" then
        hdmi_connected = true
        break
    end
end

if hdmi_connected then
    hl.monitor({ output = "HDMI-A-1", mode = "2560x1440@143.91", position = "0x0", scale = 1 })
    hl.monitor({ output = "eDP-1", mode = "1920x1080@144.42", position = "2560x0", scale = 1.2, icc = "/home/shamil/.config/CalibratedDisplayProfile-2.icc"})
    -- hl.monitor({ output = "HDMI-A-1", disabled = true})
else
    -- hl.monitor({ output = "HDMI-A-1", mode = "2560x1440@143.91", position = "0x0", scale = 1.25 })
    hl.monitor({ output = "eDP-1", mode = "1920x1080@144.42", position = "2560x0", scale = 1, icc = "/home/shamil/.config/CalibratedDisplayProfile-2.icc"})
end