
local variant = Tracker.ActiveVariantUID

-- Items
require("scripts/items_import")

-- Logic
require("scripts/logic/logic_helper")
require("scripts/logic/base_logic")
require("scripts/logic/graph_logic/logic_main")

-- Maps
if Tracker.ActiveVariantUID == "maps-u" then
    Tracker:AddMaps("maps/maps-u.json")  
else
    Tracker:AddMaps("maps/maps.json")  
end  

if PopVersion and PopVersion >= "0.23.0" then
    Tracker:AddLocations("locations/dungeons.json")
end

-- Layout
require("scripts/layouts_import")

-- Locations
-- require("scripts/locations_import")

-- AutoTracking for Poptracker
if PopVersion and PopVersion >= "0.26.0" then
    require("scripts/autotracking")
end

function OnFrameHandler()
    print("Frame Handler")
    ScriptHost:RemoveOnFrameHandler("load handler")
    -- stuff
    ScriptHost:AddWatchForCode("StateChanged", "*", StateChanged)
    ScriptHost:AddOnLocationSectionChangedHandler("location_section_change_handler", LocationHandler)
    CreateLuaManualStorageItem("manual_location_storage")
    ForceUpdate()
end
require("scripts/custom_items/luaitems")
require("scripts/utils")

-- item watches 
require("scripts/watches/watches")
require("scripts/watches/rail_watches")
require("scripts/watches/settings_watches")

ScriptHost:AddOnFrameHandler("load handler", OnFrameHandler)
