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
	["portal_c_or"] = {"portal_c_sr"}
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

-- check on key, and only active blocker if all of it's values and initial key are true
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

function InList(l, x)
	for _, i in ipairs(l) do
		if i == x then
			return true
		end
	end
	return false
end


function RailWatch(item)
	print(item)
	if railDict[item] then
		for _, rail in ipairs(railDict[item]) do
			if not AnyRail(reverseRailDict[rail]) then
				Tracker:FindObjectForCode(rail).Active = Tracker:FindObjectForCode(item).Active
			else
				Tracker:FindObjectForCode(rail).Active = true
			end
		end
	end

	if andRailDict[item] then
		for blocker, rails in pairs(andRailDict[item]) do
			Tracker:FindObjectForCode(blocker).Active = AllRail(rails) and Tracker:FindObjectForCode(item).Active
		end
	end

	-- Hard Coded Cases
	if InList(oceanSquish, item) then
		Tracker:FindObjectForCode("desert_blocker").Active = Tracker:FindObjectForCode("desert").Active and (Tracker:FindObjectForCode("ocean_source").Active or Tracker:FindObjectForCode("ocean_portal").Active)
		Tracker:FindObjectForCode("ocean_source_shared_sand").Active = Tracker:FindObjectForCode("ocean_source").Active or (Tracker:FindObjectForCode("desert").Active and Tracker:FindObjectForCode("ocean_portal").Active)
	end

	if InList(westForestSquish, item) then
		Tracker:FindObjectForCode("w_forest_blocker").Active = Tracker:FindObjectForCode("wtt").Active and (Tracker:FindObjectForCode("forest_glyph").Active or Tracker:FindObjectForCode("w_forest").Active)
	end
end

ScriptHost:AddWatchForCode("rail watch", "*", RailWatch)