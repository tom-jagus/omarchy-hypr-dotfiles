#!/usr/bin/env bash
# Owns Hyprland integration. The bootstrap repo only clones and invokes this.
set -euo pipefail
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
if [[ ${1:-} == --help || ${1:-} == -h ]]; then
  echo 'Usage: ./setup.sh'
  echo 'Link config/, add loaders to a stock Omarchy config, reload and validate.'
  exit 0
fi
(( $# == 0 )) || { echo 'Unexpected arguments.' >&2; exit 1; }
(( EUID != 0 )) || { echo 'Run as the desktop user, not root.' >&2; exit 1; }
[[ -n ${HYPRLAND_INSTANCE_SIGNATURE:-} ]] || { echo 'Run inside Hyprland.' >&2; exit 1; }
for command in hyprctl awk cmp grep readlink mktemp; do
  command -v "$command" >/dev/null || { echo "Required command missing: $command" >&2; exit 1; }
done
config_home=${XDG_CONFIG_HOME:-$HOME/.config}
defaults=${OMARCHY_PATH:-/usr/share/omarchy}/config/hypr
bash "$root/install/install-loaders.sh" "$root/config" "$config_home/hypr" "$defaults"
hyprctl reload
errors=$(hyprctl configerrors)
if [[ -n ${errors//[[:space:]]/} ]]; then
  printf 'Hyprland reported errors; integration remains installed for inspection:\n%s\n' "$errors" >&2
  exit 1
fi
printf 'Hyprland dotfiles installed and validated. Autostart applies at next login.\n'
