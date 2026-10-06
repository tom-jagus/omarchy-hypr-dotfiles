-- Hide sensitive windows and their popups from compositor screen sharing.
-- These rules do not protect ordinary browser tabs or browser extensions.

-- Proton Mail and Calendar webapps, across browser profiles.
o.window(
  { initial_class = ".*-(mail|calendar)\\.proton\\.me__.*" },
  { no_screen_share = true }
)

-- Proton Pass desktop application.
o.window("^Proton Pass$", { no_screen_share = true })

-- Signal desktop application.
o.window("^signal$", { no_screen_share = true })
