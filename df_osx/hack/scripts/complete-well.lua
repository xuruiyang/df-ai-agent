-- Complete the well system
-- 1. Ensure all intermediate levels are open space
-- 2. Construct a floor at z=178
-- 3. Build the well

-- Step 1: Make all shaft tiles open space from z=177 to z=150
print("Clearing shaft...")
for z = 177, 150, -1 do
    for x = 60, 61 do
        for y = 110, 111 do
            local block = dfhack.maps.getTileBlock(x, y, z)
            if block then
                local lx = x % 16
                local ly = y % 16
                local tt = block.tiletype[lx][ly]
                local shape = df.tiletype.attrs[tt].shape
                -- If not empty, channel it
                if shape ~= df.tiletype_shape.EMPTY and shape ~= df.tiletype_shape.RAMP_TOP then
                    block.designation[lx][ly].dig = df.tile_dig_designation.Channel
                    block.flags.designated = true
                end
            end
        end
    end
end

dfhack.run_command('dig-now')
print("Shaft cleared")

-- Step 2: Check the shaft
print("\nShaft status (60,110):")
for z = 178, 148, -1 do
    local block = dfhack.maps.getTileBlock(60, 110, z)
    if block then
        local lx = 60 % 16
        local ly = 110 % 16
        local flow = block.designation[lx][ly].flow_size
        local tt = block.tiletype[lx][ly]
        local shape = df.tiletype.attrs[tt].shape
        print(string.format("  z=%d: %s flow=%d", z, df.tiletype_shape[shape], flow))
    end
end

-- Step 3: Construct a floor at z=178 at (60,110)
-- We need to place a constructed floor
-- Use DFHack to directly set the tile type to a floor
local block178 = dfhack.maps.getTileBlock(60, 110, 178)
if block178 then
    local lx = 60 % 16
    local ly = 110 % 16
    -- Set to a constructed floor
    -- tiletype 233 = ConstructedFloor (but exact value depends on DF version)
    -- Let's find the right tiletype for constructed floor
    for tt = 0, 600 do
        local attrs = df.tiletype.attrs[tt]
        if attrs and attrs.shape == df.tiletype_shape.FLOOR
           and attrs.material == df.tiletype_material.CONSTRUCTION then
            block178.tiletype[lx][ly] = tt
            print("Set z=178 (60,110) to constructed floor (tiletype=" .. tt .. ")")
            break
        end
    end
end

-- Step 4: Build the well
local uid = tostring(df.global.world.units.active[0].id)

-- Create well components
dfhack.run_command('modtools/create-item', '-creator', uid, '-item', 'BUCKET:NONE', '-material', 'PLANT_MAT:OAK:WOOD')
dfhack.run_command('modtools/create-item', '-creator', uid, '-item', 'BLOCKS:NONE', '-material', 'INORGANIC:GRANITE')
dfhack.run_command('modtools/create-item', '-creator', uid, '-item', 'CHAIN:NONE', '-material', 'INORGANIC:IRON')
dfhack.run_command('modtools/create-item', '-creator', uid, '-item', 'TRAPPARTS:NONE', '-material', 'INORGANIC:GRANITE')

-- Move items to ground at well location
for _, item in ipairs(df.global.world.items.all) do
    if item.pos.x < 0 then
        dfhack.items.moveToGround(item, xyz2pos(60, 110, 178))
    end
end

-- Find items
local bucket, block_item, chain, mechanism
for _, item in ipairs(df.global.world.items.all) do
    if not item.flags.in_building and not item.flags.in_job then
        if item:getType() == df.item_type.BUCKET and not bucket then bucket = item end
        if item:getType() == df.item_type.BLOCKS and not block_item then block_item = item end
        if item:getType() == df.item_type.CHAIN and not chain then chain = item end
        if item:getType() == df.item_type.TRAPPARTS and not mechanism then mechanism = item end
    end
end

if bucket and block_item and chain and mechanism then
    local well = dfhack.buildings.constructBuilding{
        type = df.building_type.Well,
        pos = xyz2pos(60, 110, 178),
        items = {bucket, block_item, chain, mechanism},
    }
    if well then
        print("Well placed! ID=" .. well.id)
        dfhack.run_command('build-now')
        print("Well construction attempted!")
    else
        print("Failed to place well")
    end
else
    print("Missing well components!")
    print("bucket=" .. tostring(bucket ~= nil) .. " block=" .. tostring(block_item ~= nil) .. " chain=" .. tostring(chain ~= nil) .. " mechanism=" .. tostring(mechanism ~= nil))
end
