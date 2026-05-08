
-- Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddClearHandler("clear handler", onClearHandler)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)

Archipelago:AddSetReplyHandler("notify handler", OnNotify)
Archipelago:AddRetrievedHandler("notify launch handler", OnNotifyLaunch)

ScriptHost:AddWatchForCode("autofill tracker", "autofill_tracker", UpdateSettings)


local stamps = {
    "Stamp: Castle Town",
    "Stamp: Outset Village",
    "Stamp: Mayscore",
    "Stamp: Woodland Sanctuary",
    "Stamp: Anouki Village",
    "Stamp: Snowfall Sanctuary",
    "Stamp: Papuzia Village",
    "Stamp: Island Sanctuary",
    "Stamp: Goron Village",
    "Stamp: Valley Sanctuary",
    "Stamp: Dune Sanctuary",
    "Stamp: Wooded Temple",
    "Stamp: Blizzard Temple",
    "Stamp: Marine Temple",
    "Stamp: Mountain Temple",
    "Stamp: Desert Temple",
    "Stamp: Pirate Hideout",
    "Stamp: Trading Post",
    "Stamp: Icy Spring",
    "Stamp: Tower of Spirits"
}

local multiToggles = {
    ["Stamp: Castle Town"] = {"stamps"},
    ["Stamp: Outset Village"] = {"stamps"},
    ["Stamp: Mayscore"] = {"stamps"},
    ["Stamp: Woodland Sanctuary"] = {"stamps"},
    ["Stamp: Anouki Village"] = {"stamps"},
    ["Stamp: Snowfall Sanctuary"] = {"stamps"},
    ["Stamp: Papuzia Village"] = {"stamps"},
    ["Stamp: Island Sanctuary"] = {"stamps"},
    ["Stamp: Goron Village"] = {"stamps"},
    ["Stamp: Valley Sanctuary"] = {"stamps"},
    ["Stamp: Dune Sanctuary"] = {"stamps"},
    ["Stamp: Wooded Temple"] = {"stamps"},
    ["Stamp: Blizzard Temple"] = {"stamps"},
    ["Stamp: Marine Temple"] = {"stamps"},
    ["Stamp: Mountain Temple"] = {"stamps"},
    ["Stamp: Desert Temple"] = {"stamps"},
    ["Stamp: Pirate Hideout"] = {"stamps"},
    ["Stamp: Trading Post"] = {"stamps"},
    ["Stamp: Icy Spring"] = {"stamps"},
    ["Stamp: Tower of Spirits"] = {"stamps"}
}

local stampPacks = {
    ["stamp_pack_2"] = {"stamps"},
    ["stamp_pack_3"] = {"stamps"},
    ["stamp_pack_4"] = {"stamps"},
    ["stamp_pack_5"] = {"stamps"}
}

function MultiItems(item)
    print("multiItems:", item)
    
    -- Receieved item is a toggle, connected is a consumable
    if multiToggles[item] then
        for _, target in ipairs(multiToggles[item]) do
            target = Tracker:FindObjectForCode(target)
            incoming = Tracker:FindObjectForCode(item)
            -- print(incoming.Type)
            if incoming.Type == "toggle" then
                if incoming.Active then
                    target.AcquiredCount = target.AcquiredCount + 1
                else
                    target.AcquiredCount = target.AcquiredCount - 1
                end
            end
        end
    end

    -- Stamp packs count how many you've got, and add the needed stamps based on slot data
    if stampPacks[item] then
        local total_stamps = 0
        for stamp_pack, _ in pairs(stampPacks) do
            total_stamps = total_stamps + Tracker:FindObjectForCode(stamp_pack).AcquiredCount
        end
        print("total stamps:", total_stamps)
        for i, stamp_id in ipairs(STAMP_PACK_ORDER) do
            stamp = stamps[stamp_id+1]
            print(i, stamp_id, stamp)
            if i <= total_stamps then
                Tracker:FindObjectForCode(stamp).Active = true
            else
                Tracker:FindObjectForCode(stamp).Active = false
            end
        end
    end
end


ScriptHost:AddWatchForCode("multi items", "*", MultiItems)