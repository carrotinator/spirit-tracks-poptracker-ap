PATHS = {
    "corneria-rp", "corneria-bp", "meteo-bp", "meteo-gp", "sectory-rp", "sectory-yp",
    "aquas-rp", "katina-yp", "katina-bp", "fortuna-yp", "fortuna-bp", "zoness-rp",
    "zoness-yp", "solar-yp", "sectorx-gp", "sectorx-yp", "sectorx-bp", "sectorz-rp",
    "sectorz-bp", "macbeth-rp", "macbeth-bp", "titania-bp", "area6-rp", "bolse-bp"
}

function access_planet(planet, path1, path2, path3)
    print (planet .. " " .. path1 .. " " .. path2 .. " " .. path3)
    p1 = nil
    p1p = nil
    p2 = nil
    p2p = nil
    p3 = nil
    p3p = nil
    local p = Tracker:FindObjectForCode(planet)
    if not (path1 == "false") then
        p1 = Tracker:FindObjectForCode(path1)
    end
    if p1 then
        p1p = Tracker:FindObjectForCode("b-".. path1:sub(1,-4))
    end
    if not (path2 == "false") then
        p2 = Tracker:FindObjectForCode(path2)
    end
    if p2 then
        p2p = Tracker:FindObjectForCode("b-".. path2:sub(1,-4))
    end
    if not (path3 == "false") then
        p3 = Tracker:FindObjectForCode(path3)
    end
    if p3 then
        p3p = Tracker:FindObjectForCode("b-".. path3:sub(1,-4))
    end
    local access = Tracker:FindObjectForCode("level_access")
    local obj = Tracker:FindObjectForCode("b-"..planet)
    if access.CurrentStage == 1 then
        print("path " .. planet)
        for i, path in ipairs(PATHS) do
            local realpath = Tracker:FindObjectForCode(path)
            local objpath = Tracker:FindObjectForCode("b-"..path)
            objpath.Active = realpath.Active
        end
        if not (path1 == "false") and (p1.Active and p1p.Active) then
            obj.Active = true
            return true
        elseif not (path2 == "false") and (p2.Active and p2p.Active) then
            obj.Active = true
            return true
        elseif not (path3 == "false") and (p3.Active and p3p.Active) then
            obj.Active = true
            return true
        elseif path1 == "false" and path2 == "false" and path3 == "false" then
            obj.Active = true
            return true
        else
            obj.Active = false
            return false
        end
    else
        print("level " .. planet)
        for i, path in ipairs(PATHS) do
            local objpath = Tracker:FindObjectForCode("b-"..path)
            objpath.Active = true
        end
        if p.Active then
            obj.Active = true
            return true
        else
            obj.Active = false
        end
    end
    return false
end