-- Personal appearance overrides for Omarchy's Lua-based Hyprland configuration.
-- Load after Omarchy defaults, user configuration, and saved toggles.
-- Requires Omarchy's `hl` API and `o` helpers to be initialized first.

hl.config({
  general = {
    gaps_in = 0,
    gaps_out = 0,
    border_size = 1,
  },

  decoration = {
    dim_inactive = true,
    dim_strength = 0.15,

    blur = {
      enabled = true,
      size = 8,
      passes = 2,
    },
  },

  animations = {
    enabled = false,
  },

  scrolling = {
    column_width = 0.97,
  },
})

-- Disable whole-window transparency, including Omarchy's default opacity.
o.window(".*", { opacity = "1 1", no_blur = true })

-- Blur only terminals; background transparency is configured in each terminal.
o.window({ tag = "terminal" }, { no_blur = false })
