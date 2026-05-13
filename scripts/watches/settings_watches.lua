

function UpdateCompass(item)
    print("Testing Compass")
    print(COMPASS_LAYOUT)
    dump_table(COMPASS_LAYOUT.ItemState)
    print(" ")
    if Tracker:FindObjectForCode("dark_realm_unlock").CurrentStage > 1 then
        print("  Shards")
        print(COMPASS_LAYOUT:Get("shards"))
        COMPASS_LAYOUT:Set("mode", "shards")
        COMPASS_LAYOUT:Set("count", Tracker:FindObjectForCode("compass_shards").AcquiredCount)
        -- COMPASS_LAYOUT.Name = "Compass of Light"
        COMPASS_LAYOUT:ProvidesCodeFunc(COMPASS_LAYOUT, "compass_layout")
        COMPASS_LAYOUT.Name = "Compass of Light Shards"
    else
        print("  Compass")
        COMPASS_LAYOUT:Set("mode", "default")
        COMPASS_LAYOUT:Set("active", Tracker:FindObjectForCode("Compass").Active)
        -- COMPASS_LAYOUT.Name = "Compass Shards"
        COMPASS_LAYOUT:ProvidesCodeFunc(COMPASS_LAYOUT, "compass_layout")
        COMPASS_LAYOUT.Name = "Compass of Light"
    end
end

function UpdateCompassMax(item)
    COMPASS_LAYOUT:Set("max_shards", Tracker:FindObjectForCode(item).AcquiredCount)
    COMPASS_LAYOUT:ProvidesCodeFunc(COMPASS_LAYOUT, "compass_layout")
end

function UpdateCompassRequired(item)
    COMPASS_LAYOUT:Set("required_shards", Tracker:FindObjectForCode(item).AcquiredCount)
    COMPASS_LAYOUT:ProvidesCodeFunc(COMPASS_LAYOUT, "compass_layout")
end


ScriptHost:AddWatchForCode("UpdateCompass", "dark_realm_unlock", UpdateCompass)
ScriptHost:AddWatchForCode("UpdateCompassMax", "compass_shard_total", UpdateCompassMax)
ScriptHost:AddWatchForCode("UpdateCompassRequired", "compass_shard_count", UpdateCompassRequired)

local layoutLookup = {
    ["left_key_view"] = {file="small_key_grid", side="left"},
    ["left_boss_key_view"] = {file="boss_key_grid", side="left"},
    ["left_passenger_view"] = {file="passenger_group", side="left"},
    ["left_cargo_view"] = {file="cargo_group", side="left"},
    ["left_rail_view"] = {file="rail_group", side="left"},
    ["left_selector_view"] = {file="selector_group", side="left"},
    ["left_item_view"] = {file="item_group", side="left"},
    ["left_treasure_view"] = {file="treasure_group", side="left"},
    ["left_stamp_view"] = {file="stamp_group", side="left"},
    ["left_rabbit_view"] = {file="rabbit_grid", side="left"},
    ["left_tear_view"] = {file="tear_grid", side="left"},

    ["right_key_view"] = {file="small_key_grid", side="right"},
    ["right_boss_key_view"] = {file="boss_key_grid", side="right"},
    ["right_passenger_view"] = {file="passenger_group", side="right"},
    ["right_cargo_view"] = {file="cargo_group", side="right"},
    ["right_rail_view"] = {file="rail_group", side="right"},
    ["right_selector_view"] = {file="selector_group", side="right"},
    ["right_item_view"] = {file="item_group", side="right"},
    ["right_treasure_view"] = {file="treasure_group", side="right"},
    ["right_stamp_view"] = {file="stamp_group", side="right"},
    ["right_rabbit_view"] = {file="rabbit_grid", side="right"},
    ["right_tear_view"] = {file="tear_grid", side="right"}
}

-- Customizable layout toggle sections
function UpdateLayout(item)
    print(item)
    if Tracker:FindObjectForCode(item).Active then
        Tracker:AddLayouts("layouts/"..layoutLookup[item].side.."_enable/"..layoutLookup[item].file..".json")
    else
        Tracker:AddLayouts("layouts/"..layoutLookup[item].side.."_disable/"..layoutLookup[item].file..".json")
    end
end

-- Customizable layouts load everything correctly
function SweepLayouts()
    for layout, _ in pairs(layoutLookup) do
        UpdateLayout(layout)
    end
end

DictItemWatches(UpdateLayout, layoutLookup)
SweepLayouts()

-- Manually Reset Luaitems, THis and the sweep should probably get their own files
ResetMixedLuaItem(COMPASS_LAYOUT)
ResetMixedLuaItem(CUCCO_LAYOUT)
ResetMixedLuaItem(ICE_LAYOUT)
ResetMixedLuaItem(TOS_LAYOUT)