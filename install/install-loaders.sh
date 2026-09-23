#!/usr/bin/env bash
# Integrate runtime config/ with the user Hyprland config and Omarchy templates.
# Keep Omarchy defaults intact and refuse existing personal customizations.
set -euo pipefail
fail() { printf 'install-loaders: %s\n' "$*" >&2; exit 1; }
(( $# == 3 )) || fail 'Usage: install-loaders.sh <runtime-config-dir> <user-hypr-dir> <stock-hypr-dir>'
root=$(cd -- "$1" && pwd -P)
config=$2
defaults=$3
main="$config/hyprland.lua"
link="$config/personal"
stock="$defaults/hyprland.lua"

for name in preferences.lua init.lua monitors.lua appearance.lua workspaces.lua bindings.lua autostart.lua scripts/launch-or-focus-browser; do
  [[ -f $root/$name ]] || fail "Missing runtime config file: $root/$name"
done
[[ -f $main && ! -L $main ]] || fail "Expected an existing regular config file: $main"
if [[ -L $link ]]; then
  [[ $(readlink -f -- "$link") == "$root" ]] || fail "Existing personal link points elsewhere: $link"
elif [[ -e $link ]]; then
  fail "Refusing to replace existing path: $link"
fi
[[ -f $stock ]] || fail "Missing Omarchy template: $stock"
anchor='require("default.hypr.omarchy")'
[[ $(grep -Fxc "$anchor" "$stock" || true) == 1 ]] || fail 'Unsupported Omarchy defaults loader structure.'
grep -Fxq 'require("default.hypr.toggles")' "$stock" || fail 'Missing Omarchy toggle loader.'

# Old personal overrides in these still-loaded files would conflict or register
# duplicate startup hooks. Migration belongs in a separate, deliberate step.
for name in monitors.lua input.lua bindings.lua looknfeel.lua autostart.lua; do
  [[ -f $config/$name && -f $defaults/$name ]] && cmp -s -- "$config/$name" "$defaults/$name" ||
    fail "Existing customization or missing template: $config/$name. Migrate separately; nothing was changed."
done

stage=$(mktemp -d "$config/.hyprland-loaders.XXXXXX")
created_link=false
complete=false
cleanup() {
  if [[ $complete == false && $created_link == true && -L $link ]] &&
     [[ $(readlink -f -- "$link") == "$root" ]]; then
    rm -- "$link"
  fi
  rm -rf -- "$stage"
}
trap cleanup EXIT
cp -- "$main" "$stage/original"

# Generate the one supported installed form from the stock template. Accept
# either stock or this exact result: edited/duplicated/moved blocks fail safely.
awk '
  $0 == "require(\"default.hypr.omarchy\")" {
    print "-- BEGIN omarchy-hypr-dotfiles preferences"
    print "dofile((os.getenv(\"XDG_CONFIG_HOME\") or (os.getenv(\"HOME\") .. \"/.config\")) .. \"/hypr/personal/preferences.lua\")"
    print "-- END omarchy-hypr-dotfiles preferences"
  }
  { print }
' "$stock" > "$stage/updated"
printf '%s\n' \
  '-- BEGIN omarchy-hypr-dotfiles overrides' \
  'dofile((os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")) .. "/hypr/personal/init.lua")' \
  '-- END omarchy-hypr-dotfiles overrides' >> "$stage/updated"

if ! cmp -s -- "$main" "$stock" && ! cmp -s -- "$main" "$stage/updated"; then
  fail 'hyprland.lua contains customizations or modified loader blocks. Review/migrate them first; nothing was changed.'
fi

if [[ ! -L $link ]]; then
  ln -s -- "$root" "$link"
  created_link=true
fi
if ! cmp -s -- "$main" "$stage/updated"; then
  chmod --reference="$main" "$stage/updated"
  [[ ! -L $main ]] && cmp -s -- "$main" "$stage/original" ||
    fail 'hyprland.lua changed during installation; refusing to overwrite it.'
  mv -fT -- "$stage/updated" "$main"
fi
complete=true
printf 'Hyprland integration ready: %s -> %s\n' "$link" "$root"
