# Omarchy Hyprland dotfiles

Personal Hyprland overrides for [Omarchy](https://omarchy.org/). This is not a
standalone Hyprland configuration: it uses Omarchy's Lua `hl` API, `o` helpers,
and launch commands. The companion `omarchy-bootstrap` repository installs the
applications; this repository configures the desktop.

## What's here

- `config/preferences.lua` — disables Omarchy's preinstalled-app shortcuts while
  retaining core bindings.
- `config/init.lua` — loads the overrides after Omarchy defaults and saved toggles.
- `config/monitors.lua` — display modes, scaling, and positions.
- `config/appearance.lua` — gaps, borders, animations, dimming, and opacity.
- `config/workspaces.lua` — workspace layouts, monitor assignments, and app rules.
- `config/bindings.lua` — personal shortcuts.
- `config/autostart.lua` — applications launched at session startup.
- `config/scripts/launch-or-focus-browser` — focuses a known default browser or
  launches it; an unrecognized browser is launched without focus matching.
- `setup.sh` and `install/install-loaders.sh` — install the config and its loaders.

## Install

Run as your desktop user **inside Hyprland**, on an Omarchy installation:

```sh
./setup.sh
```

Setup links `config/` at `~/.config/hypr/personal`, adds loaders to
`~/.config/hypr/hyprland.lua`, reloads Hyprland, and checks `hyprctl configerrors`.
It expects the other user Hyprland Lua files to match Omarchy's stock templates;
existing customizations or conflicting paths must be migrated separately. It
makes no backups. Re-running setup with the same Omarchy templates and link does
not duplicate loaders.

## Customize

Edit the relevant file in `config/`. The live configuration uses the linked files.
After Lua changes, run `hyprctl reload` and `hyprctl configerrors` to validate.
Autostart commands take effect at the next session startup, not on reload.
Check app classes with `hyprctl clients -j` when adding window rules or browser
mappings.
