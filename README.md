# Omarchy Hyprland dotfiles

Personal Hyprland overrides for [Omarchy](https://omarchy.org/). This is not a
standalone Hyprland configuration: it uses Omarchy's Lua `hl` API, `o` helpers,
and launch commands from Omarchy 4.5. The companion
[omarchy-bootstrap](https://github.com/tom-jagus/omarchy-bootstrap) repository
installs applications and configures the shell; this repository owns Hyprland
configuration. Use both for the complete desktop setup.

## What's here

- `config/preferences.lua` disables Omarchy's preinstalled-app shortcuts and
  restores global workspace numbering while retaining core bindings.
- `config/init.lua` — loads the overrides after Omarchy defaults and saved toggles.
- `config/monitors.lua` — display modes, scaling, and positions.
- `config/appearance.lua` — gaps, borders, animations, dimming, and opacity.
- `config/workspaces.lua` — workspace layouts, monitor assignments, and app rules.
- `config/bindings.lua` — personal shortcuts.
- `config/autostart.lua` — applications launched at session startup.
- `config/scripts/launch-or-focus-browser` — focuses a known default browser or
  launches it; an unrecognized browser is launched without focus matching.
- `config/scripts/herdr-agent-window` provides shared Herdr startup and direct
  attachment for the dedicated agent and console launchers.
- `config/scripts/launch-or-focus-agent` and `launch-console-agent` select the
  dedicated agent and console profiles.
- `config/qconsole.lua` replaces Omarchy's console module with a user-owned copy
  that starts a Herdr-managed agent while retaining the console layout.
- `config/scripts/toggle-streaming-layout.lua` controls the streaming layout.
  `config/scripts/streaming-control` controls Stream Studio and launches OBS.
- `setup.sh` and `install/install-loaders.sh` — install the config and its loaders.

## Install

For a fresh machine, run the companion bootstrap first. It installs the required
applications and shell plugin, then invokes this repository's setup.

To install only the Hyprland configuration, run from this checkout as your desktop
user inside an Omarchy Hyprland session:

```sh
./setup.sh
```

Setup links `config/` at `~/.config/hypr/personal`, adds loaders to
`~/.config/hypr/hyprland.lua`, reloads Hyprland, and checks `hyprctl configerrors`.
It manages only the marked `omarchy-hypr-dotfiles` loader blocks and preserves
other main-config content and user files. Do not place personal edits inside the
managed blocks; setup replaces their contents. Existing user overrides remain
loaded and may conflict with the personal configuration, so review them when
migrating an older setup.

Before the first main-config rewrite, setup saves
`~/.config/hypr/hyprland.lua.before-omarchy-hypr-dotfiles` if that backup path does
not already exist. Repeat runs do not duplicate loaders or replace the backup.
Setup refuses malformed loader blocks, conflicting personal links, and main
configs without exactly one supported `require("default.hypr.omarchy")` line.

The console preload is registered by `config/preferences.lua` before Omarchy's
defaults load. Setup removes the previous managed console block. An unmarked
manual console preload is preserved; it is redundant if it loads the same module.

Standalone installation does not install applications or shell plugins. The agent
launchers require Herdr and an installed Omarchy default agent. The global
workspace configuration also needs the
[legacy-workspace-plus](https://github.com/tom-jagus/legacy-workspace-plus)
widget in place of Omarchy 4.5's per-monitor workspace widget. Bootstrap installs
it from `config/plugins.json` and selects it in `config/shell-overrides.json`.

## Customize

Edit the relevant file in `config/`. The live configuration uses the linked files.
After Lua changes, run `hyprctl reload` and `hyprctl configerrors` to validate.
Autostart commands take effect at the next session startup, not on reload.
Check app classes with `hyprctl clients -j` when adding window rules or browser
mappings.

### Workspaces

Workspace numbers are global, not separate blocks for each monitor. Workspaces
1–5 are assigned to `DP-1`, and 6–11 to `eDP-1`. Adjust these connectors in
`config/workspaces.lua` and the display settings in `config/monitors.lua` for your
hardware. Super + number selects workspaces 1–10, with 0 selecting workspace 10.
Super + Tab and Super + mouse-wheel cycle existing global workspaces.

Both ordinary Omarchy agent windows and the dedicated Herdr agent window open on
workspace 10. The Quake console uses a separate special workspace.

Proton Pass opens on workspace 11, which is assigned to `eDP-1` and uses the
scrolling layout. It has no numbered shortcut. Super + Shift + Slash launches or
focuses Proton Pass; global workspace cycling can also reach workspace 11 while
it exists. The legacy widget only displays workspaces 1–10, so it does not show
workspace 11. Closing the last window lets that workspace disappear normally.
Window-placement rules apply to new windows, not already-open ones.

The Proton Pass screen-sharing exclusion remains enabled in `config/privacy.lua`.
A separate workspace is not itself a privacy boundary.

### Herdr agents

The dedicated agent and Quake console use separate Herdr workspaces and
conversations in the `agents` session. The full interface uses `default`.

| Shortcut | Session | Herdr workspace | Interface |
|---|---|---|---|
| Super + Return | `default` | Selected in Herdr | Full Herdr interface |
| Super + Shift + A | `agents` | `assistant` | Direct agent attachment |
| Super + grave | `agents` | `console` | Direct agent attachment in the Quake console |

The shared launcher starts the `agents` session headlessly if needed, creates
the selected workspace in `~/Work` when missing, and starts the Omarchy default
agent if no agent is recognized in that workspace. The directory must already exist; create it with
`mkdir -p ~/Work` if installing standalone. Bootstrap creates it. Choose an
installed agent with `omarchy default agent <name>` when running without
bootstrap.
An existing agent is reused even if the default changes.
A shared session lock serializes startup, and per-workspace pending-launch
guards prevent blind startup retries. These launchers are intended for
dedicated agent workspaces, not arbitrary busy shells.

The dedicated window uses `org.omarchy.agent-main` and opens on workspace 10.
The console uses `org.omarchy.agent-console` on `special:qconsole`. Its native
shortcut toggles visibility without stopping the agent. The console launcher
never focuses the window itself, and another application already occupying the
console is left alone. Detach either direct attachment with Ctrl+B, then Q;
the session and agent remain running.

`config/preferences.lua` registers `config/qconsole.lua` through
`package.preload["default.hypr.qconsole"]` before
`require("default.hypr.omarchy")`. No manual preload is needed. Load the console
only through this override, not again from `config/init.lua`.

`config/qconsole.lua` is a copy of Omarchy's console module, not an automatically
updated extension. Compare it with
`/usr/share/omarchy/default/hypr/qconsole.lua` after relevant Omarchy updates.

Launcher and headless-server logs are under
`${XDG_STATE_HOME:-$HOME/.local/state}/omarchy/`, named `assistant-launch.log`,
`console-launch.log`, and `agents-server.log`. A failed launch may leave
`omarchy-agents-assistant.pending` or `omarchy-agents-console.pending` in
`$XDG_RUNTIME_DIR`. Inspect the affected session before clearing a guard;
removing it permits another launch attempt.

### Streaming layout

Press **Super + Shift + S** to reserve the rightmost quarter of the external
screen for OBS overlays, or of the internal screen when it is the only display.
This also starts Stream Studio, enables keystroke presentation, and launches or
focuses OBS. Press again to restore the layout and disable keystroke presentation;
OBS and Stream Studio remain running. OBS overlays must be configured separately.

Press **Super + Shift + K** to toggle keystroke presentation. Notifications
report its state or an error. A suspended state is not disabled: the toggle turns
suspended presentation off. Before entering sensitive information, confirm the
notification says `disabled`, or run `stream keys off` explicitly. Do not rely
on automatic prompt detection to protect passwords.

These shortcuts require OBS and the Stream Studio `stream` command and user
service to be installed. Enabling keys may initially report a suspended state
while capture starts or when desktop conditions prevent presentation.

The layout reflows tiled windows; floating windows, fullscreen windows, and the
bar are not constrained to the left three quarters. Existing bar space, display
resolution, and scaling stay unchanged. Displays are detected when the toggle is
enabled, not continuously. Reloading the config resets the layout toggle's
session-local state; it does not turn keystroke presentation off.
