-----------------------
---- LOOK AND FEEL ---- (BATTERY OPTIMISED)
-----------------------
-- Drop-in replacement for decorations.lua that disables GPU-heavy rendering
-- effects to conserve power on battery.
-- To use: change require("modules/decorations") → require("modules/decorations.battery")
-- in hyprland.lua  (or just use hyprland.battery.lua as your entry point).

-- Load generated theme colors (from theming system)
local ok, Theme = pcall(require, "themes.colors")
if not ok then
    Theme = {
        active_border_1 = "rgba(33ccffee)",
        active_border_2 = "rgba(00ff99ee)",
        inactive_border = "rgba(595959aa)",
        shadow_color    = "rgba(1a1a1aee)",
    }
end

hl.config({
    general = {
        gaps_in  = 3,   -- Reduced from 5 (less GPU fill on borders)
        gaps_out = 3,   -- Reduced from 5
        border_size = 2,
        col = {
            active_border   = { colors = {Theme.active_border_1, Theme.active_border_2}, angle = 45 },
            inactive_border = Theme.inactive_border,
        },
        resize_on_border = false,
        allow_tearing    = false,
    },

    decoration = {
        rounding       = 6,   -- Reduced from 10 (cheaper corner AA)
        rounding_power = 2,

        -- Full opacity: no per-frame alpha compositing overhead
        active_opacity   = 1,
        inactive_opacity = 1,   -- Was 0.8 — transparency compositing burns GPU cycles

        -- Shadow disabled: every shadow is an extra fullscreen blur/render pass
        shadow = {
            enabled      = false,
            range        = 0,
            render_power = 1,
            color        = 0xee1a1a1a,
        },

        -- Blur disabled: the single largest GPU power draw in Hyprland
        blur = {
            enabled  = false,
            size     = 1,
            passes   = 1,
            vibrancy = 0,
        },
    },

    animations = { enabled = true },
})

-- Minimal bezier curves
hl.curve("quick",        { type = "bezier", points = { {0.15, 0}, {0.1, 1} } })
hl.curve("almostLinear", { type = "bezier", points = { {0.5, 0.5}, {0.75, 1} } })

-- Stripped animation set (border, layers, zoom removed)
hl.animation({ leaf = "global",        enabled = true,  speed = 6,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = false })
hl.animation({ leaf = "windows",       enabled = true,  speed = 5,   bezier = "quick" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4,   bezier = "quick",        style = "popin 90%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 2,   bezier = "quick",        style = "popin 90%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 2,   bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 2,   bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3,   bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = false })
hl.animation({ leaf = "layersIn",      enabled = false })
hl.animation({ leaf = "layersOut",     enabled = false })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.5, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.5, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 2.5, bezier = "quick", style = "slide" })
hl.animation({ leaf = "zoomFactor",    enabled = false })

-- NOTE: Vivaldi / ChatGPT opacity overrides removed.
--       Full opacity on all windows avoids extra compositing passes.
