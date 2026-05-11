
Tracker:AddItems("items/items.json")
Tracker:AddItems("items/settings.json")
Tracker:AddItems("items/items_keys.json")
Tracker:AddItems("items/items_rabbits.json")
Tracker:AddItems("items/items_stamps.json")
Tracker:AddItems("items/items_tears.json")
Tracker:AddItems("items/items_treasure.json")
Tracker:AddItems("items/items_rails.json")

-- luaitems
require("scripts/custom_items/compass_item")
COMPASS_LAYOUT = CreateMixedLuaItem("Compass of Light", "compass_layout", "/images/items/Compass of Light.png", 8, 5)
CUCCO_LAYOUT = CreateMixedLuaItem("Cargo: Cuccos", "cucco_layout", "/images/items/cargo/Cucco.png", 3, 3)
ICE_LAYOUT = CreateMixedLuaItem("Cargo: Mega Ice", "ice_layout", "/images/items/cargo/Mega Ice.png", 3, 3)
TOS_LAYOUT = CreateMixedLuaItem("Tower of Spirits", "tos", "/images/tracks/tos.png", 6, 6)