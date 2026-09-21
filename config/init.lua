-- Loaded after Omarchy defaults, user files, and saved toggles/layouts.
local directory = assert(debug.getinfo(1, "S").source:sub(2):match("^(.*)/"))

dofile(directory .. "/monitors.lua")
dofile(directory .. "/appearance.lua")
dofile(directory .. "/workspaces.lua")
dofile(directory .. "/bindings.lua")
dofile(directory .. "/autostart.lua")
