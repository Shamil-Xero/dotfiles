-------------------
---- AUTOSTART ----
-------------------
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
local function sleep(n)
    os.execute("sleep " .. tonumber(n))
end

hl.on("hyprland.start", function () 
    --   hl.exec_cmd(terminal)
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("waybar")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("swaync")
    hl.exec_cmd("hyprsunset")
    hl.exec_cmd("hyprctl setcursor 18")
    hl.exec_cmd("kdeconnectd")
    hl.exec_cmd("kdeconnect-indicator")
    hl.exec_cmd("checkupdates-notify")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("wl-clip-persist --clipboard regular")

    hl.timer(function()
        hl.exec_cmd("hyprctl hyprsunset gamma 80")
    end, {
        timeout = 1000,
        type = "oneshot"
    })
end)

-- hl.on("monitor.layout_changed", function()
--     print("Monitor layout changed")
--     configure_workspaces()
-- end)