-- Loaded by bindings.lua inside Hyprland, not by a standalone Lua process.
-- Reserve the right quarter for OBS overlays. Monitor rules currently have no
-- custom reservation; clearing it leaves the shell bar's reservation intact.
-- State is intentionally session-local and resets on config reload.
local streaming_monitor

return function()
  if streaming_monitor then
    hl.monitor({ output = streaming_monitor, reserved = 0 })
    streaming_monitor = nil
    return
  end

  local monitors = hl.get_monitors()
  local target
  for _, monitor in ipairs(monitors) do
    if not monitor.is_mirror then
      local internal = monitor.name:match("^eDP") or monitor.name:match("^LVDS") or monitor.name:match("^DSI")
      if not internal then
        target = monitor
        break
      end
      target = target or monitor
    end
  end
  if not target then return end

  -- Width is physical pixels; reservation uses scaled logical pixels.
  local width = target.transform % 2 == 1 and target.height or target.width
  local right = math.floor(width / target.scale / 4 + 0.5)
  hl.monitor({ output = target.name, reserved = { right = right } })
  streaming_monitor = target.name
end
