-- Build a Still at an alternative location
-- Try 109,102 area first, then fall back
local positions = {
    {109, 95, 178},
    {113, 98, 178},
    {113, 102, 178},
    {105, 95, 178},
}

for _, pos in ipairs(positions) do
    local x, y, z = pos[1], pos[2], pos[3]
    -- Check tiles
    local ok = true
    for dx = 0, 2 do
        for dy = 0, 2 do
            local tt = dfhack.maps.getTileType(x+dx, y+dy, z)
            if tt then
                local shape = df.tiletype.attrs[tt].shape
                if shape ~= df.tiletype_shape.FLOOR then
                    ok = false
                end
            else
                ok = false
            end
        end
    end
    if ok then
        local still = dfhack.buildings.constructBuilding{
            type = df.building_type.Workshop,
            subtype = df.workshop_type.Still,
            pos = xyz2pos(x, y, z),
            width = 3,
            height = 3,
        }
        if still then
            print("Still queued at " .. x .. "," .. y .. "," .. z .. " ID=" .. still.id)
            return
        end
    else
        print("Position " .. x .. "," .. y .. " not clear")
    end
end
print("ERROR: Could not find a valid position for the Still")
