-- Utility Script for helper functions etc.
ScriptHost:LoadScript("scripts/utils.lua")
ScriptHost:LoadScript("scripts/logic.lua")

Tracker:AddItems("items/items.json")
Tracker:AddItems("items/broadcast.json")
Tracker:AddItems("items/settings.json")
Tracker:AddMaps("maps/maps.json")

Tracker:AddLocations("locations/logic/general_logic.json")

Tracker:AddLocations("locations/planets/corneria.json")
Tracker:AddLocations("locations/planets/meteo.json")
Tracker:AddLocations("locations/planets/sectory.json")
Tracker:AddLocations("locations/planets/katina.json")
Tracker:AddLocations("locations/planets/fortuna.json")
Tracker:AddLocations("locations/planets/aquas.json")
Tracker:AddLocations("locations/planets/solar.json")
Tracker:AddLocations("locations/planets/sectorx.json")
Tracker:AddLocations("locations/planets/zoness.json")
Tracker:AddLocations("locations/planets/sectorz.json")
Tracker:AddLocations("locations/planets/macbeth.json")
Tracker:AddLocations("locations/planets/titania.json")
Tracker:AddLocations("locations/planets/area6.json")
Tracker:AddLocations("locations/planets/bolse.json")
Tracker:AddLocations("locations/planets/venom.json")
Tracker:AddLocations("locations/planets/goals.json")

Tracker:AddLayouts("layouts/items.json")
Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/broadcast.json")
Tracker:AddLayouts("layouts/settings.json")

ScriptHost:LoadScript("scripts/broadcast-logic.lua")
if PopVersion and PopVersion >= "0.18.0" then
    ScriptHost:LoadScript("scripts/autotracking.lua")
end