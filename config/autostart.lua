-- Work-session startup. Load after Omarchy's defaults initialize `o`.
-- Runs on Hyprland startup, not on configuration reload.
-- o.launch_on_start already wraps commands with uwsm-app.

-- Night-light service; schedules are configured separately in hyprsunset.conf.
o.launch_on_start("hyprsunset")

-- Main terminal: use the same dedicated app ID as the keybinding and
-- workspace 2 rule, keeping music TUIs and other terminals independent.
o.launch_on_start("omarchy launch or focus tui --app-id=org.omarchy.main-terminal herdr")

-- Resolve the default-browser helper relative to this configuration file.
local config_file = debug.getinfo(1, "S").source:sub(2)
local config_dir = assert(config_file:match("^(.*)/"), "Load autostart.lua using a path")
local browser_script = config_dir .. "/scripts/launch-or-focus-browser"
o.launch_on_start("bash " .. o.shell_quote(browser_script))

-- Communication. Signal's launcher already implements launch-or-focus.
o.launch_on_start("omarchy launch signal")

-- Mail and calendar: match webapp classes rather than changing page titles.
o.launch_on_start("omarchy launch or focus webapp " .. o.shell_quote("^.*-mail\\.proton\\.me__.*$") .. " https://mail.proton.me")
o.launch_on_start("omarchy launch or focus webapp " .. o.shell_quote("^.*-calendar\\.proton\\.me__.*$") .. " https://calendar.proton.me")
