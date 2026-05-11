
local function CanProvideCodeFunc(self, code)
    return code == self.ItemState["code"]
end

local function UpdateShards(self)
    print("Updating Shards")
    count = self:Get("count")
    self:SetOverlay(count)
    if count >= self.ItemState["required_shards"] then
        self:SetOverlayColor("#00FF00")
    else
        self:SetOverlayColor("")
    end
    if count == 0 then
        self.IconMods = "@disabled"
    else
        self.IconMods = "brightness|1.0"
    end
end

local function UpdateDefault(self)
    self:SetOverlay("")
    if self:Get("active") then
         self.IconMods = "brightness|1.0"
    else
        self.IconMods = "@disabled"
    end
end

local function OnLeftClickFunc(self)
    print("Left Click")
    if self:Get("mode") == "default" then
        self:Set("active", true)
        UpdateDefault(self)
    elseif self:Get("mode") == "shards" then
        count = math.min(self:Get("count") + 1, self.ItemState["max_shards"])
        print("Count: "..count.."/"..self.ItemState["max_shards"])
        self:Set("count", count)
        UpdateShards(self)
    end
end

local function OnRightClickFunc(self)
    print("Right Click")
    if self:Get("mode") == "default" then
        self:Set("active", false)
        UpdateDefault(self)
    elseif self:Get("mode") == "shards" then
        self:Set("count", math.max(self:Get("count") - 1, 0))
        UpdateShards(self)
    end
end

local function OnMiddleClickFunc(self)
    OnLeftClickFunc(self)
end

local function UpdateVisuals(self)
    print("Updating compass_layout visuals")
    if self:Get("mode") == "default" then
        UpdateDefault(self)
    elseif self:Get("mode") == "shards" then
        UpdateShards(self)
    end
end

local function ProvidesCodeFunc(self, code)
    UpdateVisuals(self)
    if CanProvideCodeFunc(self, code) then
        return 1
    end
    return 0
end

local function SaveManualLocationStorageFunc(self)
    return {
        -- save everything from ItemState in here separately
        MANUAL_LOCATIONS = self.ItemState.MANUAL_LOCATIONS,
        MANUAL_LOCATIONS_ORDER = self.ItemState.MANUAL_LOCATIONS_ORDER,
        Target = self.ItemState.Target,
        Name = self.Name,
        Icon = self.Icon
    }
end

local function LoadManualLocationStorageFunc(self, data)
    if data ~= nil and self.Name == data.Name then
        -- load everything from ItemState in here separately
        self.ItemState.MANUAL_LOCATIONS = data.MANUAL_LOCATIONS
        self.ItemState.MANUAL_LOCATIONS_ORDER = data.MANUAL_LOCATIONS_ORDER
        self.Icon = ImageReference:FromPackRelativePath(data.Icon)
    else
    end
end

function CreateMixedLuaItem(name, code, icon, max_shards, required_shards)
    local self = ScriptHost:CreateLuaItem()
    -- self.Type = "custom"
    self.Name = name --code --
    self.Icon = ImageReference:FromPackRelativePath(icon)
    self.ItemState = {
        MANUAL_LOCATIONS = {
            ["default"] = {}
        },
        MANUAL_LOCATIONS_ORDER = {},
        -- you can add many more custom stuff in here
        ["mode"] = "default",
        ["count"] = 0,
        ["active"] = false,
        ["max_shards"] = max_shards,  -- original item was compass/shards, can't be bothered to update variable names
        ["required_shards"] = required_shards,
        ["code"] = code
    }

    self.CanProvideCodeFunc = CanProvideCodeFunc
    self.OnLeftClickFunc = OnLeftClickFunc -- your_custom_leftclick_function_here
    self.OnRightClickFunc = OnRightClickFunc -- your_custom_rightclick_function_here
    self.OnMiddleClickFunc = OnMiddleClickFunc -- your_custom_middleclick_function_here
    self.ProvidesCodeFunc = ProvidesCodeFunc
    self.SaveFunc = SaveManualLocationStorageFunc
    self.LoadFunc = LoadManualLocationStorageFunc


    return self
end