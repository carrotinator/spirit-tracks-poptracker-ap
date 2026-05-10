

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
    else
        print("  Compass")
        COMPASS_LAYOUT:Set("mode", "default")
        COMPASS_LAYOUT:Set("active", Tracker:FindObjectForCode("Compass").Active)
        -- COMPASS_LAYOUT.Name = "Compass Shards"
        COMPASS_LAYOUT:ProvidesCodeFunc(COMPASS_LAYOUT, "compass_layout")
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