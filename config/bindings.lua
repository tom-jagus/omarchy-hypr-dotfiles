-- Load after Omarchy's default bindings.
-- Set omarchy_preinstalled_bindings = false BEFORE loading Omarchy defaults
-- in the main config; setting it here would be too late.

-- Resolve adjacent scripts from this file's location, including when the
-- repository is linked at ~/.config/hypr/personal.
local config_file = debug.getinfo(1, "S").source:sub(2)
local config_dir = assert(config_file:match("^(.*)/"), "Load bindings.lua using a path")
local browser_script = config_dir .. "/scripts/launch-or-focus-browser"
local agent_script = config_dir .. "/scripts/launch-or-focus-agent"

-- Always replace existing bindings rather than adding duplicate actions.
local function bind(keys, description, command)
  hl.unbind(keys)
  o.bind(keys, description, command)
end

-- Restore the global workspace cycling used before Omarchy 4.5.
bind("SUPER + TAB", "Next workspace",
  hl.dsp.focus({ workspace = "e+1" }))
bind("SUPER + SHIFT + TAB", "Previous workspace",
  hl.dsp.focus({ workspace = "e-1" }))
bind("SUPER + CTRL + TAB", "Former workspace",
  hl.dsp.focus({ workspace = "previous" }))
bind("SUPER + mouse_down", "Scroll active workspace forward",
  hl.dsp.focus({ workspace = "e+1" }))
bind("SUPER + mouse_up", "Scroll active workspace backward",
  hl.dsp.focus({ workspace = "e-1" }))

-- Main terminal has its own stable app ID, independent of its changing title.
-- Use the same command for autostart when that configuration is added.
bind("SUPER + RETURN", "Main terminal", "omarchy launch or focus tui --app-id=org.omarchy.main-terminal herdr --session default")
bind("SUPER + SHIFT + B", "Browser", "bash " .. o.shell_quote(browser_script))

-- Music TUIs get distinct app IDs from Omarchy's TUI launcher.
bind("SUPER + SHIFT + ALT + M", "Spotify Player", { tui = "spotify_player", focus = true })
bind("SUPER + SHIFT + M", "Music", { tui = "cliamp", focus = true })

-- Signal's own launcher already implements launch-or-focus.
bind("SUPER + SHIFT + G", "Signal", { omarchy = "signal" })
bind("SUPER + SHIFT + SLASH", "Proton Pass",
  { launch = "proton-pass", focus = "^(proton-pass|Proton Pass)$" })

-- Keep native ChatGPT and the browser-hosted ChatGPT independent.
bind("SUPER + SHIFT + A", "Omarchy Agent", "bash " .. o.shell_quote(agent_script))
-- Native ChatGPT is optional; the webapp remains available independently.
if o.cmd_present("chatgpt") then
  bind("SUPER + SHIFT + CTRL + A", "ChatGPT app", { launch = "chatgpt", focus = "^chatgpt$" })
end
bind("SUPER + SHIFT + ALT + A", "ChatGPT webapp",
  "omarchy launch or focus webapp " .. o.shell_quote("^.*-chatgpt\\.com__.*$") .. " https://chatgpt.com")

bind("SUPER + SHIFT + C", "Calendar", { webapp = "https://calendar.proton.me", focus = true })
bind("SUPER + SHIFT + E", "Mail", { webapp = "https://mail.proton.me", focus = true })
bind("SUPER + SHIFT + Y", "YouTube",
  o.launch_webapp_sole("^.*-youtube[.]com__.*$", "https://youtube.com/"))
bind("SUPER + SHIFT + X", "X", { webapp = "https://x.com/", focus = true })

-- Actions rather than application launches.
bind("SUPER + M", "Mute microphone", "omarchy-audio-input-mute")
bind("SUPER + ALT + M", "Mute audio", "omarchy-audio-output-volume mute-toggle")

bind("SUPER + SHIFT + S", "Toggle streaming layout",
  dofile(config_dir .. "/scripts/toggle-streaming-layout.lua"))
