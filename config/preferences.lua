-- Loaded before Omarchy defaults. Keep core/essential bindings, but omit
-- optional preinstalled-app bindings that our personal bindings replace.
omarchy_preinstalled_bindings = false

-- Register the personal console before Omarchy requires its default module.
local directory = assert(debug.getinfo(1, "S").source:sub(2):match("^(.*)/"))
package.preload["default.hypr.qconsole"] = function()
  return dofile(directory .. "/qconsole.lua")
end

-- Keep global workspace numbers instead of per-monitor blocks.
-- Loaded before require("default.hypr.omarchy").
package.preload["default.hypr.monitor-workspaces"] = function()
  local workspaces = {}

  function workspaces.focus(id)
    return hl.dsp.focus({ workspace = tostring(id) })
  end

  function workspaces.move_window(id, follow)
    return hl.dsp.window.move({
      workspace = tostring(id),
      follow = follow ~= false,
    })
  end

  function workspaces.move_to_monitor(direction)
    return hl.dsp.workspace.move({ monitor = direction })
  end

  function workspaces.move_window_to_monitor(direction)
    return hl.dsp.window.move({ monitor = direction })
  end

  o.workspaces = workspaces
  return workspaces
end
