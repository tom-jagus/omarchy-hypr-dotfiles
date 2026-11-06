-- Loaded before Omarchy defaults. Keep core/essential bindings, but omit
-- optional preinstalled-app bindings that our personal bindings replace.
omarchy_preinstalled_bindings = false

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
