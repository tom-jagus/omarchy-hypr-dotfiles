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
  },

  animations = {
    enabled = false,
  },

  scrolling = {
    column_width = 0.97,
  },
})

-- Preserve Omarchy's per-application opt-outs from default opacity.
o.window({ tag = "default-opacity" }, { opacity = "0.93 0.89" })
