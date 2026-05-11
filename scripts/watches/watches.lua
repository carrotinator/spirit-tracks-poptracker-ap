
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

-- Tower of Spirits
local function TowerOfSpiritsBase(item)
    
    if not Tracker:FindObjectForCode("tos_unlock_base_item").Active then
        TOS_LAYOUT.ItemState["active"] = true
        TOS_LAYOUT.ItemState["mode"] = "default"
    elseif Tracker:FindObjectForCode("tos_section_unlocks").CurrentStage == 2 then
        TOS_LAYOUT.ItemState["count"] = Tracker:FindObjectForCode("progressivetossection").AcquiredCount
        TOS_LAYOUT.ItemState["mode"] = "shards"
    else
        TOS_LAYOUT.ItemState["active"] = Tracker:FindObjectForCode("towerofspiritsbase").Active
        TOS_LAYOUT.ItemState["mode"] = "default"
    end
    TOS_LAYOUT:ProvidesCodeFunc(TOS_LAYOUT, "tos")
end

ListItemWatches(TowerOfSpiritsBase, {"tos_unlock_base_item", "tos_section_unlocks", "towerofspiritsbase", "progressivetossection"})

-- Tears of Light
local function BigTears(item)
    index = string.sub(item, -1, -1)
    print(index)
    if Tracker:FindObjectForCode(item).Active then
        Tracker:FindObjectForCode("TearToS"..index).AcquiredCount = 3
    end
end

local bigTears = {}
for i=1,6 do
    bigTears[i] = "big_TearToS"..i
end

ListItemWatches(BigTears, bigTears)

local function GlobalTears(item)
    send_weapons = false
    if item == "tear_global" then
        count = Tracker:FindObjectForCode(item).AcquiredCount
        if count >= 4 then
            send_weapons = true
        end
    elseif item == "big_tear_global" then
        count = 3
        if Tracker:FindObjectForCode(item).AcquiredCount >= 2 then
            send_weapons = true
        end
    end
    
    for i=1,6 do
        Tracker:FindObjectForCode("TearToS"..i).AcquiredCount = count
    end

    if send_weapons and Tracker:FindObjectForCode("spirit_weapons").Active then
        Tracker:FindObjectForCode("bow_of_light").Active = true
        Tracker:FindObjectForCode("lokomo_sword").Active = true
    end
end

ListItemWatches(GlobalTears, {"tear_global", "big_tear_global", "spirit_weapons"})

-- Upgrade the sword if playing with spirit weapons
local function CheckSword(item)
    if Tracker:FindObjectForCode("spirit_weapons").Active and Tracker:FindObjectForCode("ProgSword").CurrentStage > 0 and Tracker:FindObjectForCode("lokomo_sword").Active then
        Tracker:FindObjectForCode("ProgSword").CurrentStage = 2
    end
end
ListItemWatches(CheckSword, {"ProgSword", "lokomo_sword", "spirit_weapons"})

local function ProgressiveTears(item)
    total_tears = Tracker:FindObjectForCode("tear_progressive").AcquiredCount + Tracker:FindObjectForCode("big_tear_progressive").AcquiredCount * 3
    
    for section, order in pairs(TOWER_SECTION_LOOKUP) do
        if total_tears >= (order-1)*3 then
            Tracker:FindObjectForCode("TearToS"..section).AcquiredCount = total_tears-(order-1)*3
        end
    end
    if Tracker:FindObjectForCode("spirit_weapons").Active and SLOT_DATA["section_count"] then
        if total_tears > math.min(SLOT_DATA["section_count"], 5) * 3 then
            Tracker:FindObjectForCode("bow_of_light").Active = true
            Tracker:FindObjectForCode("lokomo_sword").Active = true
        end
    end
end
ListItemWatches(ProgressiveTears, {"tear_progressive", "big_tear_progressive", "spirit_weapons"})
