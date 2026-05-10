-- from https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console
-- dumps a table in a readable string
function dump_table(o, depth)
    if depth == nil then
        depth = 0
    end
    if type(o) == 'table' then
        local tabs = ('\t'):rep(depth)
        local tabs2 = ('\t'):rep(depth + 1)
        local s = '{\n'
        for k, v in pairs(o) do
            if type(k) ~= 'number' then
                k = '"' .. k .. '"'
            end
            s = s .. tabs2 .. '[' .. k .. '] = ' .. dump_table(v, depth + 1) .. ',\n'
        end
        return s .. tabs .. '}'
    else
        return tostring(o)
    end
end

-- making lua pythonic lol, equivalent to in
function containsItem(list, item)
    if list and item then
        for _, value in pairs(list) do
            if value == item then
                return true
            end
        end
    end
    
    return false
end

-- making lua pythonic lol, for any values
function InList(l, x)
	for _, i in ipairs(l) do
		if i == x then
			return true
		end
	end
	return false
end

-- These functions make more efficient watches for lists of items, rather than calling watchis on all items
function ListItemWatches(func, item_list)
	for _, item in ipairs(item_list) do
		print("Creating list watch for "..item.." with func "..tostring(func))
		name = tostring(func).."_"..item
		ScriptHost:AddWatchForCode(name, item, func)
	end
end

function DictItemWatches(func, item_dict)
	for item, _ in pairs(item_dict) do
		print("Creating dict watch for "..item.." with func "..tostring(func))
		name = tostring(func).."_"..item
		ScriptHost:AddWatchForCode(name, item, func)
	end
end