-- Personal monitor configuration for Omarchy's Lua-based Hyprland setup.
-- Load after Omarchy's default and user monitor configuration.
-- Requires the `hl` API to be initialized first.
-- Workspace assignments belong in a separate workspace configuration.

local monitor_scale = 1.6
local internal_width = 1920
local internal_height = 1080
local internal_refresh = 60.01

-- Monitor positions are integer logical pixels, accounting for scaling.
local external_x = math.floor(internal_width / monitor_scale + 0.5)

-- Retain Omarchy's GTK scaling alongside fractional monitor scaling.
hl.env("GDK_SCALE", "2")

-- Fallback for other connected displays.
hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = monitor_scale,
})

-- Internal display on the left.
hl.monitor({
  output = "eDP-1",
  mode = string.format("%dx%d@%g", internal_width, internal_height, internal_refresh),
  position = "0x0",
  scale = monitor_scale,
})

-- External display on the right, aligned at the top.
-- Follow the internal display's scaled width automatically.
hl.monitor({
  output = "DP-1",
  mode = "2560x1440@144",
  position = string.format("%dx0", external_x),
  scale = monitor_scale,
})
