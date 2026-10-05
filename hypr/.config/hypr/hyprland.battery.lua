
-- https://wiki.hypr.land/Configuring/Start/
-- BATTERY-OPTIMISED Hyprland entry point.
-- To activate: symlink or copy this to hyprland.lua, or launch Hyprland with
--   HYPRLAND_CONFIG=~/.config/hypr/hyprland.battery.lua
-- Each *.battery.lua module is a drop-in replacement for its counterpart.

require("modules/autostart.battery")   -- Battery autostart (fewer daemons, power-saver governor)
require("modules/keybinds")             -- Keybindings           — unchanged
require("modules/decorations.battery")  -- No blur/shadows, minimal animations
require("modules/env")                  -- Env vars              — unchanged
require("modules/input")               -- Input                 — unchanged
require("modules/layout")              -- Layout                — unchanged
require("modules/misc")                -- Misc                  — unchanged
require("modules/monitors.battery")    -- 60 Hz refresh rates
require("modules/windows")             -- Window/workspace rules — unchanged
