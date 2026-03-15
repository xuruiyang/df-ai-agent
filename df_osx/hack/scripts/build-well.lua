-- Build a well over the water
-- Water is at z=177, we need the well on z=178 (one level above)
-- The channel we dug should let us see down to z=177

-- First check where the water actually is
print("Scanning for water in cistern area...")
local water_pos = nil
for x = 55, 70 do
    for y = 100, 115 do
        local block = dfhack.maps.getTileBlock(x, y, 177)
        if block then
            local lx = x % 16
            local ly = y % 16
            if block.designation[lx][ly].flow_size >= 4 then
                water_pos = {x=x, y=y, z=177}
                print(string.format("Good water at %d,%d,%d flow=%d", x, y, 177, block.designation[lx][ly].flow_size))
            end
        end
    end
end

if not water_pos then
    print("No deep water found. Checking any water...")
    for x = 55, 70 do
        for y = 100, 115 do
            local block = dfhack.maps.getTileBlock(x, y, 177)
            if block then
                local lx = x % 16
                local ly = y % 16
                if block.designation[lx][ly].flow_size > 0 then
                    water_pos = {x=x, y=y, z=177}
                    print(string.format("Water at %d,%d,%d flow=%d", x, y, 177, block.designation[lx][ly].flow_size))
                    break
                end
            end
        end
        if water_pos then break end
    end
end

if not water_pos then
    print("ERROR: No water found in cistern area!")
    return
end

-- Check tile above water (z=178) for well placement
local well_x, well_y, well_z = water_pos.x, water_pos.y, 178
local block = dfhack.maps.getTileBlock(well_x, well_y, well_z)
if block then
    local lx = well_x % 16
    local ly = well_y % 16
    local tt = block.tiletype[lx][ly]
    local shape = df.tiletype.attrs[tt].shape
    print(string.format("Tile above water at %d,%d,%d shape=%s", well_x, well_y, well_z, df.tiletype_shape[shape]))

    -- If it's a floor (channeled), we can build a well
    -- If it's a wall, we need to dig it
    if shape == df.tiletype_shape.WALL then
        print("Need to channel this tile first...")
        block.designation[lx][ly].dig = df.tile_dig_designation.Channel
        block.flags.designated = true
        dfhack.run_command('dig-now')
        -- Refresh tile type
        tt = block.tiletype[lx][ly]
        shape = df.tiletype.attrs[tt].shape
        print("After channeling, shape=" .. df.tiletype_shape[shape])
    end
end

-- Build the well
-- A well needs: 1 bucket, 1 block, 1 chain/rope, 1 mechanism
-- Let's create the needed items and build
local uid = tostring(df.global.world.units.active[0].id)

-- Create well components
dfhack.run_command('modtools/create-item', '-creator', uid, '-item', 'BUCKET:NONE', '-material', 'PLANT_MAT:OAK:WOOD')
dfhack.run_command('modtools/create-item', '-creator', uid, '-item', 'BLOCKS:NONE', '-material', 'INORGANIC:GRANITE')
dfhack.run_command('modtools/create-item', '-creator', uid, '-item', 'CHAIN:NONE', '-material', 'INORGANIC:IRON')
dfhack.run_command('modtools/create-item', '-creator', uid, '-item', 'TRAPPARTS:NONE', '-material', 'INORGANIC:GRANITE')

-- Move items to ground
for _, item in ipairs(df.global.world.items.all) do
    if item.pos.x < 0 then
        dfhack.items.moveToGround(item, xyz2pos(well_x, well_y, well_z))
    end
end

-- Find items for construction
local bucket, block_item, chain, mechanism
for _, item in ipairs(df.global.world.items.all) do
    if not item.flags.in_building and not item.flags.in_job then
        if item:getType() == df.item_type.BUCKET and not bucket then
            bucket = item
        elseif item:getType() == df.item_type.BLOCKS and not block_item then
            block_item = item
        elseif item:getType() == df.item_type.CHAIN and not chain then
            chain = item
        elseif item:getType() == df.item_type.TRAPPARTS and not mechanism then
            mechanism = item
        end
    end
end

if bucket and block_item and chain and mechanism then
    print("All well components found!")
    local well = dfhack.buildings.constructBuilding{
        type = df.building_type.Well,
        pos = xyz2pos(well_x, well_y, well_z),
        items = {bucket, block_item, chain, mechanism},
    }
    if well then
        print("Well placed at " .. well_x .. "," .. well_y .. "," .. well_z .. " ID=" .. well.id)
        dfhack.run_command('build-now')
        print("Well construction complete!")
    else
        print("Failed to construct well building")
    end
else
    print("Missing components:")
    print("  Bucket: " .. tostring(bucket ~= nil))
    print("  Block: " .. tostring(block_item ~= nil))
    print("  Chain: " .. tostring(chain ~= nil))
    print("  Mechanism: " .. tostring(mechanism ~= nil))
end
