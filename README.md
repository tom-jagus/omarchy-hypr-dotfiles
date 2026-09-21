# omarchy-hypr-dotfiles

Personal, actively maintained Hyprland overrides for **Omarchy**. These are not
standalone Hyprland defaults: they depend on Omarchy's Lua `hl` API, `o` helpers,
and launch commands. Developed against Omarchy 4.0.4-1 / Hyprland 0.56.2-2.

```text
README.md
setup.sh                 Integration orchestrator
config/                  Live configuration, linked into Hyprland
├── preferences.lua      Settings loaded before Omarchy defaults
├── init.lua             Overrides loaded after defaults/toggles
├── appearance.lua       Gaps, borders, dimming, animations, opacity
├── monitors.lua         Display modes, scaling, calculated positioning
├── workspaces.lua       Monitor/workspace assignments and app placement
├── bindings.lua         Personal launch-or-focus shortcuts
├── autostart.lua        Work-session startup applications
└── scripts/
    └── launch-or-focus-browser
install/                 Installation tools, not linked into Hyprland
└── install-loaders.sh
```

The companion **omarchy-bootstrap** repository (locally `../omarchy-bootstrap`)
installs applications and prepares the desktop. This repository owns the live
Hyprland preferences and their installation.

## Installation

Run `./setup.sh` as your desktop user inside Hyprland, or let the companion
bootstrap clone this repository to `~/src/personal/omarchy-hypr-dotfiles` and
invoke it. This repository, not bootstrap, owns every integration step:

1. Check that Omarchy's user Lua files still match its installed templates.
2. Link `~/.config/hypr/personal` to this checkout's `config/` directory:
   `~/src/personal/omarchy-hypr-dotfiles/config` for bootstrap-managed installs.
3. Add a managed preferences loader immediately before Omarchy defaults.
4. Append a managed `init.lua` loader after all existing default/user/toggle loads.
5. Reload Hyprland and check configuration errors.

`preferences.lua` disables preinstalled-app bindings while keeping core bindings.
`init.lua` loads monitors, appearance, workspaces, bindings, then autostart.
This ordering preserves 1-pixel borders and explicit workspace layouts despite
saved Omarchy toggles. Our binding helper unbinds each replaced shortcut first:
Super+Return, Super+Shift+B, and Super+Shift+Ctrl+A replace stock terminal,
browser, and agent bindings; the remaining app shortcuts replace corresponding
preinstalled-app shortcuts when those are enabled.

Retries do not duplicate loaders or replace an existing correct link. Existing
customized Lua files, edited loader blocks, conflicting paths, and incompatible
Omarchy templates cause a clear error before modification. Migrate older personal
configurations separately; do not use this as a reset tool. No backups are made.
If Hyprland reports errors after installation, setup fails and leaves the files
available for inspection rather than claiming success or reverting blindly.
Autostart launches happen on the next login, not during reload.

The installer has only been exercised with temporary configurations/mocked
Hyprland commands during development; this machine has not been activated.

`bindings.lua` and `autostart.lua` resolve `scripts/launch-or-focus-browser`
relative to their own location inside `config/`, so moving or symlinking that
directory keeps the helper accessible. No hardcoded checkout path is required.

## Editing

- Adjust display settings in `monitors.lua`; the right display's position is
  calculated from the internal display's width and scale.
- Keep explicit workspace/app rules in `workspaces.lua`.
- The main terminal uses app ID `org.omarchy.main-terminal`, distinct from TUIs.
- Native ChatGPT is optional; its binding is registered only when installed.
- Browser focus is resolved on every invocation. Extend its class mapping when
  introducing another browser and verify classes with `hyprctl clients -j`.

Once activated, validate changes with `hyprctl reload` and
`hyprctl configerrors`. Autostart hooks run on session startup, not on reload.
New app-class matches and laptop-only monitor behavior still need live testing.

Installation scripts use Bash and standard Unix tools; Python is not required.
The loader installer accepts explicit runtime-config, user-config, and
stock-template paths for testing against temporary copies without touching the
live configuration. For example, use the repository's `config/` directory as its
first argument and temporary copies of Omarchy's templates for the other two.

Only `config/` is linked; README and installation tools stay out of the live
configuration directory. An existing link to the old repository root is treated
as a conflict, not silently replaced.
