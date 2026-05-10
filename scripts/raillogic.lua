function medalCheck()
    local medals = Tracker:FindObjectForCode("medal")
    local required = Tracker:FindObjectForCode("required_medals")
    return medals.AcquiredCount >= required.AcquiredCount
end

-- link together
local railDict = {
	["fire_glyph"] = {"fire_source_shared_glyph", "fire_glyph_w", "fire_glyph_n"},
	["fire_glyph_w"] = {"fire_source_shared_glyph", "fire_glyph_n", "fire_glyph"},
	["fire_glyph_n"] = {"fire_source_shared_glyph", "fire_glyph_w", "fire_glyph"},

	["fire_source"] = {"fire_source_tos", "fire_source_shared_glyph", "fire_source_shared_mtt"},
	["fire_source_tos"] = {"fire_source", "fire_source_shared_glyph", "fire_source_shared_mtt"},
	
	["forest_glyph"] = {"forest_glyph_outset", "forest_source_shared_fg"},
	["forest_glyph_outset"] = {"forest_glyph", "forest_source_shared_fg"},
	["forest_source"] = {"forest_source_shared_fg", "forest_source_shared_wtt", "forest_source_shared_e"},
	["ocean_shortcut"] = {"forest_source_shared_e", "ocean_shortcut_s"},
	["ocean_shortcut_s"] = {"forest_source_shared_e", "ocean_shortcut"},
	
	["mtt"] = {"fire_source_shared_mtt", "mtt_w", "mtt_e"},
	["mtt_w"] = {"fire_source_shared_mtt", "mtt", "mtt_e"},
	["mtt_e"] = {"fire_source_shared_mtt", "mtt_w", "mtt"},
	
	["ocean_source"] = {"ocean_source_tos", "ocean_source_shared_sand", "ocean_source_shared_oct"},
	["ocean_source_tos"] = {"ocean_source", "ocean_source_shared_sand", "ocean_source_shared_oct"},
	["oct"] = {"ocean_source_shared_oct"},
	
	["btt"] = {"snow_source_shared", "btt_snowfall", "btt_anouki"},
	["btt_snowfall"] = {"snow_source_shared", "btt", "btt_anouki"},
	["btt_anouki"] = {"snow_source_shared", "btt_snowfall", "btt"},
	["snow_glyph"] = {"snow_glyph_rabbit"},
	["snow_glyph_rabbit"] = {"snow_glyph"},
	["snow_source"] = {"snow_source_shared", "snow_source_tos"},
	["snow_source_tos"] = {"snow_source", "snow_source_shared"},

	["wtt"] = {"forest_source_shared_wtt"},
	["snow_bridge"] = {"snow_bridge_south"},
	["snow_bridge_south"] = {"snow_bridge"},

	["ocean_glyph"] = {"ocean_glyph_upper", "ocean_glyph_tp", "ocean_glyph_n"},
	["ocean_glyph_upper"] = {"ocean_glyph", "ocean_glyph_tp", "ocean_glyph_n"},
	["ocean_glyph_tp"] = {"ocean_glyph", "ocean_glyph_upper", "ocean_glyph_n"},
	["ocean_glyph_n"] = {"ocean_glyph", "ocean_glyph_upper", "ocean_glyph_tp"},

	["n_castle"] = {"n_castle_w"},
	["n_castle_w"] = {"n_castle"},

	["portal_d_sr"] = {"portal_d_mr"},
	["portal_b_sr"] = {"portal_b_fr"},
	["portal_c_sr"] = {"portal_c_or"},
	["portal_a_sr"] = {"portal_a_fr"},
	["portal_a_fr"] = {"portal_a_sr"},
	["portal_e_fr"] = {"portal_e_mr"},
	["portal_g_fr"] = {"portal_g_or"},
	["portal_b_fr"] = {"portal_b_sr"},
	["portal_e_mr"] = {"portal_e_fr"},
	["portal_d_mr"] = {"portal_d_sr"},
	["portal_f_mr"] = {"portal_f_or"},
	["portal_h_e"] = {"portal_h_w"},
	["portal_h_w"] = {"portal_h_e"},
	["portal_g_or"] = {"portal_g_fr"},
	["portal_f_or"] = {"portal_f_mr"},
	["portal_c_or"] = {"portal_c_sr"},

	["islandtracks"] = {"ocean_glyph", "pirate", "las"},
	["coastaltracks"] = {"ocean_glyph", "ocean_shortcut", "mayscore_bridge", "tp_portal"},
	["completedoceanglyph"] = {"ocean_glyph", "oct", "pirate", "las", "ocean_shortcut", "ocean_portal", "ocean_source"},
	["majoroceantracks"] = {"ocean_glyph", "oct", "ocean_source"},
	["valleytracks"] = {"fire_glyph", "disorientation", "gorge"},
	["majorfiretracks"] = {"fire_glyph", "mtt", "fire_source"},
	["completedfireglyph"] = {"fire_glyph", "mtt", "sand_shortcut", "dom", "eote", "disorientation", "gorge", "fire_source"},
	["woodlandtracks"] = {"wtt", "w_castle", "w_wt"},
	["majorforesttracks"] = {"wtt", "forest_source"},
	["completedforestglyph"] = {"wtt", "ocean_shortcut", "mayscore_bridge", "tp_portal", "w_castle", "w_forest", "cave", "w_wt", "n_castle", "snow_bridge", "forest_source"},
	["blizzardtracks"] = {"btt", "snowdrift", "slippery", "snow_source"},
	["majorsnowtracks"] = {"btt", "snow_source"},
	["completedsnowglyph"] = {"btt", "snowdrift", "slippery", "w_wt", "n_castle", "snow_bridge", "nicyspring", "gorge", "snow_source"},
	["thawlandtracks"] = {"btt", "n_castle", "nicyspring", "gorge", "snow_source"},
	["oceantracks"] = {"oct", "las", "ocean_portal", "ocean_source"},
	["mountaintracks"] = {"mtt", "dtt", "dom", "eote"},
	["majordeserttracks"] = {"dtt", "desert", "sandsource"},
	["completeddeserttracks"] = {"dtt", "desert", "sand_shortcut", "dom", "sandsource"},
	["dunetracks"] = {"dtt", "desert", "sand_shortcut", "sandsource"},
	["minorsnowtracks"] = {"snowdrift", "slippery", "w_wt", "n_castle", "snow_bridge", "nicyspring", "gorge"},
	["piratetracks"] = {"pirate", "ocean_shortcut", "ocean_portal"},
	["minoroceantracks"] = {"pirate", "las", "ocean_shortcut", "ocean_portal"},
	["minorforesttracks"] = {"ocean_shortcut", "mayscore_bridge", "tp_portal", "w_castle", "w_forest", "cave", "w_wt", "n_castle", "snow_bridge"},
	["westernforesttracks"] = {"w_forest", "cave", "w_wt"},
	["borderlandstracks"] = {"w_wt", "n_castle", "snow_bridge"},
	["anoukivillagetracks"] = {"w_wt", "snow_bridge"},
	["castletracks"] = {"n_castle", "forest_source"},
	["aridtracks"] = {"ocean_portal", "desert", "sand_shortcut", "fire_source", "sandsource"},
	["minorfiretracks"] = {"sand_shortcut", "dom", "eote", "disorientation", "gorge"},
	["minordeserttracks"] = {"sand_shortcut", "dom"},
	["towertracks"] = {"forest_source", "snow_source", "ocean_source", "fire_source"},
}

-- block switching off the key if any values are still active
local reverseRailDict = {
	["fire_source_shared_glyph"] = {"fire_source", "fire_glyph"},
	["fire_source_shared_mtt"] = {"fire_source", "mtt"},
	["forest_source_shared_fg"] = {"forest_source", "forest_glyph"},
	["forest_source_shared_wtt"] = {"forest_source", "wtt"},
	["ocean_source_shared_oct"] = {"ocean_source", "oct"},
	["ocean_source_shared_sand"] = {"ocean_source", "desert"},
	["snow_source_shared"] = {"snow_source", "btt"},
	["forest_source_shared_e"] = {"forest_source", "ocean_shortcut"}
}

-- check on key, and only active blocker if all of it"s values and initial key are true
local andRailDict = {
	["fire_glyph"] = {
		["sand_sc_blocker"] = {"sand_shortcut"},
		["fire_snow_blocker"] = {"snow_source", "btt"}
	},
	["sand_shortcut"] = {
		["sand_sc_blocker"] = {"fire_glyph"},
		["sand_shortcut_shared"] = {"desert"}
	},
	["snow_source"] = {["fire_snow_blocker"] = {"fire_glyph", "btt"}},
	["btt"] = {["fire_snow_blocker"] = {"fire_glyph", "snow_source"}},
	["desert"] = {["sand_shortcut_shared"] = {"sand_shortcut"}},
	
	["wtt"] = {
		["w_wt_blocker"] = {"w_wt"},
		["snow_bridge_blocker"] = {"snow_bridge"},
		["w_castle_blocker"] = {"w_castle"},
		["wtt_blocker_fg"] = {"forest_glyph"}},
	["w_wt"] = {["w_wt_blocker"] = {"wtt"}},
	["snow_bridge"] = {["snow_bridge_blocker"] = {"wtt"}},
	["w_castle"] = {["w_castle_blocker"] = {"wtt"}},
	["forest_glyph"] = {
		["wtt_blocker_fg"] = {"wtt"},
		["ocean_shortcut_blocker"] = {"ocean_shortcut"}},
	["ocean_shortcut"] = {["ocean_shortcut_blocker"] = {"forest_glyph"}},

	["compass"] = {["compass_blocker"] = {"cave"}},
	["cave"] = {["compass_blocker"] = {"compass"}},

	["tp_portal"] = {["tp_portal_blocker"] = {"ocean_glyph"}},
	["ocean_glyph"] = {["tp_portal_blocker"] = {"tp_portal"}}
}

-- Special case that needed hard coding
local oceanSquish = {
	"desert",
	"ocean_source",
	"ocean_source_tos",
	"ocean_portal"
}

local westForestSquish = {
	"forest_glyph",
	"w_forest",
	"wtt"
}

local snurglarKeys = {
    "keyring_snurglar",
    "SnurglarKeys"
}


function AnyRail(railList)
	if not railList then
		return false
	end
	
	for _, rail in ipairs(railList) do
		if Tracker:FindObjectForCode(rail).Active then
			return true
		end
	end
	return false
end

function AllRail(railList)
	if not railList then
		return false
	end

	for _, rail in ipairs(railList) do
		if not Tracker:FindObjectForCode(rail).Active then
			return false
		end
	end
	return true
end

-- Linked rail sections
function RailWatch(item)
	print("Railwatch: "..item)
	for _, rail in ipairs(railDict[item]) do
		if not AnyRail(reverseRailDict[rail]) then
			Tracker:FindObjectForCode(rail).Active = Tracker:FindObjectForCode(item).Active
		else
			Tracker:FindObjectForCode(rail).Active = true
		end
	end
end
DictItemWatches(RailWatch, railDict)

-- AND rail sections
function RailWatchAnd(item)
	print("RailwatchAnd: "..item)
	for blocker, rails in pairs(andRailDict[item]) do
		Tracker:FindObjectForCode(blocker).Active = AllRail(rails) and Tracker:FindObjectForCode(item).Active
	end
end
DictItemWatches(RailWatchAnd, andRailDict)

-- Hard coded ocean situation
function RailWatchOceanSquish(item)
	print("Ocean Squish: "..item)
	Tracker:FindObjectForCode("desert_blocker").Active = Tracker:FindObjectForCode("desert").Active and (Tracker:FindObjectForCode("ocean_source").Active or Tracker:FindObjectForCode("ocean_portal").Active)
	Tracker:FindObjectForCode("ocean_source_shared_sand").Active = Tracker:FindObjectForCode("ocean_source").Active or (Tracker:FindObjectForCode("desert").Active and Tracker:FindObjectForCode("ocean_portal").Active)
end
ListItemWatches(RailWatchOceanSquish, oceanSquish)

-- Hard coded forest situation
function RailWatchForestSquish(item)
	print("Forest Squish: "..item)
	Tracker:FindObjectForCode("w_forest_blocker").Active = Tracker:FindObjectForCode("wtt").Active and (Tracker:FindObjectForCode("forest_glyph").Active or Tracker:FindObjectForCode("w_forest").Active)
end
ListItemWatches(RailWatchForestSquish, westForestSquish)


-- Snurglar door
function SnurglarDoor(item)
	print("Snurglar Door: "..item)
	print(Tracker:FindObjectForCode("SnurglarKeys").AcquiredCount..Tracker:FindObjectForCode("lock_mtt").Active)
	Tracker:FindObjectForCode("lock_mtt").Active = Tracker:FindObjectForCode("SnurglarKeys").AcquiredCount == 3
end
ScriptHost:AddWatchForCode("Snurglar Door", "SnurglarKeys", SnurglarDoor)

-- Compass and Shards
local function CompassShards(item)
    COMPASS_LAYOUT.ItemState["count"] = Tracker:FindObjectForCode(item).AcquiredCount
    COMPASS_LAYOUT:ProvidesCodeFunc(COMPASS_LAYOUT, "compass_layout")
	if Tracker:FindObjectForCode("dark_realm_unlock").AcquiredCount > 1 then
		if Tracker:FindObjectForCode(item).AcquiredCount >= Tracker:FindObjectForCode("compass_shard_count").AcquiredCount then
			Tracker:FindObjectForCode("Compass").Active = true
		else
			Tracker:FindObjectForCode("Compass").Active = false
		end
	end
end

local function Compass(item)
    COMPASS_LAYOUT.ItemState["active"] = Tracker:FindObjectForCode(item).Active
    COMPASS_LAYOUT:ProvidesCodeFunc(COMPASS_LAYOUT, "compass_layout")
	Tracker:FindObjectForCode("compass_rail").Active = Tracker:FindObjectForCode(item).Active
end

local function CompassRail(item)
	Tracker:FindObjectForCode("Compass").Active = Tracker:FindObjectForCode(item).Active
end

ScriptHost:AddWatchForCode("CompassShards", "compass_shards", CompassShards)
ScriptHost:AddWatchForCode("Compass", "Compass", Compass)
ScriptHost:AddWatchForCode("CompassRail", "compass_rail", CompassRail)

local portalRailReqs = {
	["portalunlock_d"] = {track1="nicyspring", track2="mtt", portal="portal_d_sr"},
	["portalunlock_b"] = {track1="tp_portal", track2="btt", portal="portal_b_sr"},
	["portalunlock_c"] = {track1="snow_bridge", track2="oct", portal="portal_c_sr"},
	["portalunlock_a"] = {track1="snow_glyph", track2="forest_glyph", portal="portal_a_sr"},
	["portalunlock_e"] = {track1="cave", track2="fire_glyph", portal="portal_d_sr"},
	["portalunlock_g"] = {track1="ocean_portal", track2="ocean_glyph", portal="portal_e_fr"},
	["portalunlock_f"] = {track1="sand_shortcut", track2="oct", portal="portal_f_mr"},
	["portalunlock_h"] = {track1="dtt", track2="desert", portal="portal_h_e"},
}

local railsWithPortals = {
	["nicyspring"] = {{track="mtt", portal="portal_d_sr", item="portalunlock_d", gem=true}},
	["mtt"] = {{track="nicyspring", portal="portal_d_sr", item="portalunlock_d", gem=false}},

	["tp_portal"] = {{track="btt", portal="portal_b_sr", item="portalunlock_b", gem=true}},
	["btt"] = {{track="tp_portal", portal="portal_b_sr", item="portalunlock_b", gem=false}},

	["snow_bridge"] = {{track="oct", portal="portal_c_sr", item="portalunlock_c", gem=true}},
	["oct"] = {
		{track="snow_bridge", portal="portal_c_sr", item="portalunlock_c", gem=false},
		{track="sand_shortcut", portal="portal_f_mr", item="portalunlock_f", gem=false}
	},
	["sand_shortcut"] = {{track="oct", portal="portal_f_mr", item="portalunlock_f", gem=true}},

	["snow_glyph"] = {{track="forest_glyph", portal="portal_a_sr", item="portalunlock_a", gem=true}},
	["forest_glyph"] = {{track="snow_glyph", portal="portal_a_sr", item="portalunlock_a", gem=false}},

	["cave"] = {{track="fire_glyph", portal="portal_e_fr", item="portalunlock_e", gem=true}},
	["fire_glyph"] = {{track="cave", portal="portal_e_fr", item="portalunlock_e", gem=false}},

	["ocean_portal"] = {{track="ocean_glyph", portal="portal_g_fr", item="portalunlock_g", gem=true}},
	["ocean_glyph"] = {{track="ocean_portal", portal="portal_g_fr", item="portalunlock_g", gem=false}},

	["dtt"] = {{track="desert", portal="portal_h_e", item="portalunlock_h", gem=true}},
	["desert"] = {{track="dtt", portal="portal_h_e", item="portalunlock_h", gem=false}},
}

-- Portal Unlocks items
local function PortalItems(item)
	portal = Tracker:FindObjectForCode(portalRailReqs[item].portal)
	host_item = Tracker:FindObjectForCode(item)

	if Tracker:FindObjectForCode("portal_tracks").Active then
		portal.Active = host_item.Active and Tracker:FindObjectForCode(portalRailReqs[item].track1).Active and Tracker:FindObjectForCode(portalRailReqs[item].track2).Active
	else
		portal.Active = host_item.Active
	end
end

local function RailsThatUnlockPortals(item)
	host_track = Tracker:FindObjectForCode(item)
	-- portal_checks = Tracker:FindObjectForCode("portal_checks").Active
	portal_track_opt = Tracker:FindObjectForCode("portal_tracks").Active
	has_cannon = Tracker:FindObjectForCode("cannon").Active
	portal_opt = Tracker:FindObjectForCode("portal_behavior").CurrentStage

	for i, data in ipairs(railsWithPortals[item]) do
		track = Tracker:FindObjectForCode(data.track)
		portal = Tracker:FindObjectForCode(data.portal)
		portal_item = Tracker:FindObjectForCode(data.item)
		has_tracks = track.Active and host_track.Active
		
		-- open portals, no location
		if portal_opt == 1 then
			portal.Active = has_tracks
			-- ignore case of no cannon and portal locs for now
			-- need a way to block only one portal on the map.
			-- Map sandwich? clickbox > portal blocker > portal icon
		
		-- require item, no location
		elseif portal_opt == 2 then
			if not portal_track_opt then
				portal.Active = portal_item.Active
			else
				portal.Active = portal_item.Active and has_tracks
			end
			-- ignore case of no cannon and portal locs for now

		-- one-way portals
		elseif portal_opt == 0 then
			portal.Active = has_cannon and has_tracks
		end

	end
end

-- Cannon Unlocks one-way portals
local function CannonPortalSweep(item)
	for key, _ in pairs(railsWithPortals) do
		RailsThatUnlockPortals(key)
	end
end

DictItemWatches(PortalItems, portalRailReqs)
DictItemWatches(RailsThatUnlockPortals, railsWithPortals)
ScriptHost:AddWatchForCode("CannonPortalSweep", "cannon", CannonPortalSweep)
ScriptHost:AddWatchForCode("CannonPortalSweep_portal_tracks", "portal_tracks", CannonPortalSweep)  -- useful
ScriptHost:AddWatchForCode("CannonPortalSweep_portal_behavior", "portal_behavior", CannonPortalSweep)