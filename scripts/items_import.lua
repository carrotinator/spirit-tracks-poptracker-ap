
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
COMPASS_LAYOUT = CreateCompassLuaItem("compass_layout")