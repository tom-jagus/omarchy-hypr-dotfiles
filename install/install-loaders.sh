#!/usr/bin/env bash
# Own only the marked loaders. Preserve user configuration and Omarchy defaults.
set -euo pipefail
fail() { printf 'install-loaders: %s\n' "$*" >&2; exit 1; }
(( $# == 2 )) || fail 'Usage: install-loaders.sh <runtime-config-dir> <user-hypr-dir>'
root=$(cd -- "$1" && pwd -P)
config=$2
main="$config/hyprland.lua"
link="$config/personal"

for name in preferences.lua init.lua monitors.lua appearance.lua workspaces.lua privacy.lua bindings.lua autostart.lua qconsole.lua \
  scripts/launch-or-focus-browser scripts/herdr-agent-window \
  scripts/launch-or-focus-agent scripts/launch-console-agent scripts/toggle-streaming-layout.lua; do
  [[ -f $root/$name ]] || fail "Missing runtime config file: $root/$name"
done
[[ -f $main && ! -L $main ]] || fail "Expected an existing regular config file: $main"
if [[ -L $link ]]; then
  [[ $(readlink -f -- "$link") == "$root" ]] || fail "Existing personal link points elsewhere: $link"
elif [[ -e $link ]]; then
  fail "Refusing to replace existing path: $link"
fi

stage=$(mktemp -d "$config/.hyprland-loaders.XXXXXX")
trap 'rm -rf -- "$stage"' EXIT
cp -- "$main" "$stage/original"

# Refresh our marked blocks without comparing unrelated files to stock templates.
# The former console block is retired: preferences.lua now registers that preload.
awk '
  function fail(message) {
    print "install-loaders: " message > "/dev/stderr"
    bad = 1
    exit 1
  }
  /^-- BEGIN omarchy-hypr-dotfiles (preferences|console|overrides)$/ {
    if (block != "" || seen[$4]++) fail("Duplicate or nested loader block.")
    block = $4
    next
  }
  /^-- END omarchy-hypr-dotfiles (preferences|console|overrides)$/ {
    if (block == "" || block != $4) fail("Mismatched loader block.")
    block = ""
    next
  }
  block != "" { next }
  /^[[:space:]]*require\("default.hypr.omarchy"\)[[:space:]]*$/ {
    defaults++
    print "-- BEGIN omarchy-hypr-dotfiles preferences"
    print "dofile((os.getenv(\"XDG_CONFIG_HOME\") or (os.getenv(\"HOME\") .. \"/.config\")) .. \"/hypr/personal/preferences.lua\")"
    print "-- END omarchy-hypr-dotfiles preferences"
  }
  { print }
  END {
    if (bad) exit 1
    if (block != "") fail("Unclosed loader block.")
    if (defaults != 1) fail("Expected exactly one Omarchy defaults loader.")
    print "-- BEGIN omarchy-hypr-dotfiles overrides"
    print "dofile((os.getenv(\"XDG_CONFIG_HOME\") or (os.getenv(\"HOME\") .. \"/.config\")) .. \"/hypr/personal/init.lua\")"
    print "-- END omarchy-hypr-dotfiles overrides"
  }
' "$stage/original" > "$stage/updated"

if ! cmp -s -- "$main" "$stage/updated"; then
  [[ ! -L $main ]] && cmp -s -- "$main" "$stage/original" ||
    fail 'hyprland.lua changed during installation; refusing to overwrite it.'
  # Preserve the first pre-install version for manual recovery.
  backup="$main.before-omarchy-hypr-dotfiles"
  [[ -e $backup || -L $backup ]] || cp -p -- "$main" "$backup"
  chmod --reference="$main" "$stage/updated"
  [[ -L $link ]] || ln -s -- "$root" "$link"
  mv -fT -- "$stage/updated" "$main"
else
  [[ -L $link ]] || ln -s -- "$root" "$link"
fi
printf 'Hyprland integration ready: %s -> %s\n' "$link" "$root"
