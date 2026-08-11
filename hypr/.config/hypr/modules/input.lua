---------------
---- INPUT ----
---------------

hl.config({ -- Default input configuration, see https://wiki.hypr.land/Configuring/Basics/Input/
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",
        kb_options = "caps:backspace",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = true,
        },
    },
})

hl.gesture({ -- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({ -- RedDragon Mouse
    name        = "compx-2.4g-wireless-receiver", 
    sensitivity = 0,
    accel_profile = "flat",
})

hl.device({ -- Touchpad
    name        = "elan0001:00-04f3:327e-touchpad",
    sensitivity = 0,
    -- accel_profile = "adaptive",
})

-- See Tablet settings https://wiki.hypr.land/Configuring/Basics/Variables/#input