-- Load after Omarchy defaults and saved workspace-layout toggles.

local function assign_workspace(id, monitor, layout, default)
  hl.workspace_rule({
    workspace = id,
    monitor = monitor,
    layout = layout,
    default = default or false,
  })
end

local function place_window(workspace, match)
  hl.window_rule({ match = match, workspace = workspace })
end

-- Monitor assignments and layouts.
assign_workspace("1", "DP-1", "dwindle", true)
assign_workspace("2", "DP-1", "dwindle")
assign_workspace("3", "DP-1", "dwindle")
assign_workspace("4", "DP-1", "scrolling")
assign_workspace("5", "DP-1", "dwindle")
assign_workspace("6", "eDP-1", "scrolling", true)
assign_workspace("7", "eDP-1", "scrolling")
assign_workspace("8", "eDP-1", "scrolling")
assign_workspace("9", "eDP-1", "scrolling")
assign_workspace("10", "eDP-1", "dwindle")

-- 1: Browsers supported by Omarchy, plus Vivaldi.
-- Full-class matches keep separate webapps unaffected; (?i) ignores case.
-- Verify classes for newly installed browsers with `hyprctl clients -j`.
place_window(1, { class = "(?i)(vivaldi-stable|vivaldi|vivaldi-snapshot)" })
place_window(1, { class = "(?i)chromium" })
place_window(1, { class = "(?i)google-chrome" })
place_window(1, { class = "(?i)brave-browser" })
place_window(1, { class = "(?i)brave-origin" })
place_window(1, { class = "(?i)microsoft-edge" })
place_window(1, { class = "(?i)(firefox|org\\.mozilla\\.firefox)" })
place_window(1, { class = "(?i)(zen|zen-browser)" })

-- 2: Main terminal only.
place_window(2, { class = "org\\.omarchy\\.main-terminal" })

-- 3: Work.
place_window(3, { initial_class = ".*github\\.com.*" })
place_window(3, { class = "(?i)(gimp.*|org\\.gimp\\.GIMP.*)" })

-- 4: Video.
place_window(4, { initial_class = ".*youtube\\.com.*" })
place_window(4, { initial_class = ".*netflix\\.com.*" })
place_window(4, { initial_class = ".*crunchyroll\\.com.*" })
place_window(4, { initial_class = ".*hbomax\\.com.*" })
place_window(4, { initial_class = ".*skyshowtime\\.com.*" })
place_window(4, { initial_title = ".*netflix\\.com.*" })
place_window(4, { initial_title = ".*crunchyroll\\.com.*" })
place_window(4, { initial_title = ".*hbomax\\.com.*" })
place_window(4, { initial_title = ".*skyshowtime\\.com.*" })

-- 5: Social media. The hyphen avoids matching the end of netflix.com.
place_window(5, { initial_class = ".*-x\\.com.*" })
place_window(5, { initial_title = "x\\.com.*" })

-- 6: Communication.
-- Verify new apps' classes with `hyprctl clients -j` when they are running.
place_window(6, { class = "signal" })
place_window(6, { class = "discord" })
place_window(6, { class = "(?i)whatsapp" })
place_window(6, { initial_class = ".*whatsapp\\.com.*" })
place_window(6, { class = "(?i)(proton-meet|proton meet|me\\.proton\\.Meet)" })
place_window(6, { initial_class = ".*meet\\.proton\\.me.*" })
place_window(6, { class = "(?i)(zoom|zoom\\.us|us\\.zoom\\.Zoom)" })
place_window(6, { initial_class = ".*zoom\\.us.*" })

-- 7: Mail and calendar.
place_window(7, { initial_class = ".*mail\\.proton.*" })
place_window(7, { initial_class = ".*calendar\\.proton.*" })

-- 8: Music.
place_window(8, { initial_class = ".*cliamp.*" })
place_window(8, { initial_class = ".*spotify_player.*" })
place_window(8, { title = ".*spotify_player.*" })
place_window(8, { class = "(?i)spotify" })
place_window(8, { initial_class = ".*open\\.spotify\\.com.*" })

-- 9: Security and OBS.
place_window(9, { class = "Proton Pass" })
place_window(9, { class = "proton\\.vpn\\.app\\.gtk" })
place_window(9, { class = "(?i)(obs|com\\.obsproject\\.Studio)" })

-- 10: AI.
place_window(10, { class = ".*chatgpt.*" })
place_window(10, { class = "org\\.omarchy\\.agent" })
