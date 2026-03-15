-- Build a trade depot using constructBuilding and complete it with build-now
local x, y, z = 94, 98, 178

-- Remove any shrubs/saplings in the 5x5 area first
for dx = 0, 4 do
    for dy = 0, 4 do
        local block = dfhack.maps.getTileBlock(x+dx, y+dy, z)
        if block then
            local tt = block.tiletype[x+dx - block.map_pos.x][y+dy - block.map_pos.y]
            local shape = df.tiletype.attrs[tt].shape
            if shape == df.tiletype_shape.SHRUB or shape == df.tiletype_shape.SAPLING then
                -- Replace with floor
                block.tiletype[x+dx - block.map_pos.x][y+dy - block.map_pos.y] = df.tiletype.OpenSpace
                -- Actually just remove plant items/grass
            end
        end
    end
end

-- Clear plants at these positions
dfhack.run_command('cleanplants')

local bld = dfhack.buildings.constructBuilding{
    type = df.building_type.TradeDepot,
    pos = xyz2pos(x, y, z),
    width = 5,
    height = 5,
}

if bld then
    print("Trade depot queued, ID=" .. bld.id)
    print("Running build-now to complete it instantly...")
    dfhack.run_command('build-now')
    print("Done! Trade depot should be ready.")
else
    print("ERROR: Failed to place trade depot at " .. x .. "," .. y .. "," .. z)
end
