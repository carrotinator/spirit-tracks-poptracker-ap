-- Utility Script for helper functions etc.
ScriptHost:LoadScript("scripts/utils.lua")
ScriptHost:LoadScript("scripts/logic.lua")

Tracker:AddItems("items/items.json")
Tracker:AddItems("items/broadcast.json")
Tracker:AddItems("items/settings.json")
Tracker:AddMaps("maps/maps.json")

Tracker:AddLocations("locations/logic/general_logic.json")

Tracker:AddLayouts("layouts/items.json")
Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/broadcast.json")
Tracker:AddLayouts("layouts/settings.json")

ScriptHost:LoadScript("scripts/broadcast-logic.lua")
if PopVersion and PopVersion >= "0.18.0" then
    ScriptHost:LoadScript("scripts/autotracking.lua")
end