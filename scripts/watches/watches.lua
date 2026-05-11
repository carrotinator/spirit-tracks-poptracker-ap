
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

local keyringLookup = {
    ["keyring_snurglar"] = {small="SnurglarKeys"},
    ["keyring_wood"] = {small="WoodSmall", big="WoodBig"},
    ["keyring_tos2"] = {small="ToS2Small"},
    ["keyring_tos4"] = {small="Tos4Small"},
    ["keyring_tos5"] = {small="ToS5Small", big="Tos5Big"},
    ["keyring_tos6"] = {small="ToS6Small"},
    ["keyring_bliz"] = {small="BlizzSmall", big="BlizzBig"},
    ["keyring_marine"] = {small="Marinemall", big="MarinBig"},
    ["keyring_mount"] = {small="MountSmall", big="MountBig"},
    ["keyring_desert"] = {small="DesSmall", big="DesBig"},
    ["keyring_tos3"] = {big="ToS3Big"},
}

local allBigKeys = {
    "WoodBig",
    "BlizzBig",
    "MarinBig",
    "MountBig",
    "DesBig",
    "ToS3Big",
    "Tos5Big"
}

-- Receieved item is a toggle, connected is a consumable
function MultiToggles(item)
    print("MultiToggles: "..item)
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
DictItemWatches(MultiToggles, multiToggles)

-- Stamp packs count how many you've got, and add the needed stamps based on slot data
function StampPacks(item)
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
DictItemWatches(StampPacks, stampPacks)

-- Rabbit stuff
local rabbitList = {}
local rabbitCounts = {1, 2, 3, 4, 5, 10}
local rabbitTypes = {
    "grass",
    "snow",
    "ocean",
    "mountain",
    "sand"
}
for _, rabbitType in ipairs(rabbitTypes) do
    for _, count in ipairs(rabbitCounts) do
        table.insert(rabbitList, rabbitType.."rabbit_"..count)
    end
end

dump_table(rabbitList)

-- calculate total rabbits
function RabbitPacks(item)
    for _, rabbitType in ipairs(rabbitTypes) do
        if string.find(item, rabbitType.."rabbit_") then
            print("  "..rabbitType)
            local rabbit_count = 0
            for _, count in ipairs(rabbitCounts) do
                rabbit_count = rabbit_count + Tracker:FindObjectForCode(rabbitType.."rabbit_"..count).AcquiredCount
            end
            print("  "..rabbitType.."rabbit has total count: "..rabbit_count)
            Tracker:FindObjectForCode(rabbitType.."rabbit").AcquiredCount = math.min(rabbit_count, 10)
            break
        end
    end
end
ListItemWatches(RabbitPacks, rabbitList)

-- set keyrings
function Keyrings(item)
    if Tracker:FindObjectForCode(item).Active then
        if keyringLookup[item].small then
            Tracker:FindObjectForCode(keyringLookup[item].small).AcquiredCount = Tracker:FindObjectForCode(keyringLookup[item].small).MaxCount
        end
        if keyringLookup[item].big and Tracker:FindObjectForCode("big_keyrings").Active then
            Tracker:FindObjectForCode(keyringLookup[item].big).Active = true
        end
    end
end
DictItemWatches(Keyrings, keyringLookup)

-- Special functions for Ice with various settings
local function UpdateIce(item)
    if Tracker:FindObjectForCode("randomize_cargo").CurrentStage == 3 then
        ICE_LAYOUT.ItemState["count"] = Tracker:FindObjectForCode("cargo:megaice").AcquiredCount
        ICE_LAYOUT.ItemState["mode"] = "shards"
        ICE_LAYOUT:ProvidesCodeFunc(ICE_LAYOUT, "ice_layout")
    else
        ICE_LAYOUT.ItemState["active"] = Tracker:FindObjectForCode("cargo:megaice").AcquiredCount > 0
        ICE_LAYOUT.ItemState["mode"] = "default"
        ICE_LAYOUT:ProvidesCodeFunc(ICE_LAYOUT, "ice_layout")
    end
end

ListItemWatches(UpdateIce, {"cargo:megaice", "randomize_cargo"})

-- Special functions for Cuccos
local function UpdateCuccos(item)
    if Tracker:FindObjectForCode("randomize_cargo").CurrentStage == 3 then
        CUCCO_LAYOUT.ItemState["count"] = Tracker:FindObjectForCode("cargo:cuccos_multi").AcquiredCount
        CUCCO_LAYOUT.ItemState["mode"] = "shards"
        CUCCO_LAYOUT:ProvidesCodeFunc(CUCCO_LAYOUT, "cucco_layout")
    else
        CUCCO_LAYOUT.ItemState["active"] = Tracker:FindObjectForCode("cargo:cuccos_single").Active
        CUCCO_LAYOUT.ItemState["mode"] = "default"
        CUCCO_LAYOUT:ProvidesCodeFunc(CUCCO_LAYOUT, "cucco_layout")
    end
end
ListItemWatches(UpdateCuccos, {"cargo:cuccos_single", "cargo:cuccos_multi", "randomize_cargo"})


local function TempDebug(item)
    print(Tracker:FindObjectForCode("randomize_cargo"))
    print(Tracker:FindObjectForCode("randomize_cargo").CurrentStage)
    print(Tracker:FindObjectForCode("randomize_cargo").Icon)
end

ScriptHost:AddWatchForCode("TempDebug", "cucco_layout", TempDebug)