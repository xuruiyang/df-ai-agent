-- Build key infrastructure: dining hall, deeper mining, smelter

-- === DINING HALL on z=177 ===
-- Place tables and chairs in the workshop hall area
local function get_free_boulder()
    for _, item in ipairs(df.global.world.items.all) do
        if item:getType() == df.item_type.BOULDER and not item.flags.in_building and not item.flags.in_job and not item.flags.forbid then
            return item
        end
    end
    return nil
end

-- Build 5 table+chair pairs for a dining hall at (93-97, 112-116, z=177)
local tables_placed = 0
local chairs_placed = 0
for i = 0, 4 do
    -- Table
    local boulder1 = get_free_boulder()
    if boulder1 then
        local tbl = dfhack.buildings.constructBuilding{
            type = df.building_type.Table,
            pos = xyz2pos(93 + i * 2, 113, 177),
            items = {boulder1},
        }
        if tbl then tables_placed = tables_placed + 1 end
    end
    -- Chair next to table
    local boulder2 = get_free_boulder()
    if boulder2 then
        local chr = dfhack.buildings.constructBuilding{
            type = df.building_type.Chair,
            pos = xyz2pos(93 + i * 2, 114, 177),
            items = {boulder2},
        }
        if chr then chairs_placed = chairs_placed + 1 end
    end
end
dfhack.run_command('build-now')
print(string.format("Dining hall: %d tables, %d chairs placed", tables_placed, chairs_placed))

-- Make one table a dining room
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.Table and bld.flags.exists and bld.z == 177 then
        bld.is_room = true
        -- Set room size
        bld.room.x = 8
        bld.room.y = 4
        print("Dining room created from table ID=" .. bld.id)
        break
    end
end

-- === DEEPER MINING: Dig to ore levels ===
-- Gold at z=100-126, Iron (from galena) at z=129-152
-- Let's dig stairs from z=176 down to z=140 for galena mining

local stair_count = 0
for z = 175, 140, -1 do
    for x = 100, 101 do
        for y = 110, 111 do
            local block = dfhack.maps.getTileBlock(x, y, z)
            if block then
                local lx = x % 16
                local ly = y % 16
                local tt = block.tiletype[lx][ly]
                local shape = df.tiletype.attrs[tt].shape
                if shape == df.tiletype_shape.WALL then
                    block.designation[lx][ly].dig = df.tile_dig_designation.UpDownStair
                    block.flags.designated = true
                    stair_count = stair_count + 1
                end
            end
        end
    end
end
print("Mining stairway designated: " .. stair_count .. " tiles (z=175 to z=140)")

-- Dig an exploration hall at z=140 (galena ore level)
local function designate_dig(x1, y1, z, w, h)
    local count = 0
    for x = x1, x1 + w - 1 do
        for y = y1, y1 + h - 1 do
            local block = dfhack.maps.getTileBlock(x, y, z)
            if block then
                local lx = x % 16
                local ly = y % 16
                local tt = block.tiletype[lx][ly]
                local shape = df.tiletype.attrs[tt].shape
                if shape == df.tiletype_shape.WALL then
                    block.designation[lx][ly].dig = df.tile_dig_designation.Default
                    block.flags.designated = true
                    count = count + 1
                end
            end
        end
    end
    return count
end

local ore_count = designate_dig(90, 105, 140, 25, 15)
print("Ore exploration hall designated: " .. ore_count .. " tiles at z=140")

-- Dig it all
dfhack.run_command('dig-now')
print("All digging complete!")

-- === BUILD SMELTER on z=177 ===
local boulder3 = get_free_boulder()
if boulder3 then
    local smelter = dfhack.buildings.constructBuilding{
        type = df.building_type.Furnace,
        subtype = df.furnace_type.Smelter,
        pos = xyz2pos(103, 109, 177),
        width = 3,
        height = 3,
        items = {boulder3},
    }
    if smelter then
        print("Smelter built, ID=" .. smelter.id)
        dfhack.run_command('build-now')
    end
end

-- === BUILD METALSMITH FORGE on z=177 ===
local boulder4 = get_free_boulder()
if boulder4 then
    -- Need an anvil for the forge... check if we have one
    local anvil = nil
    for _, item in ipairs(df.global.world.items.all) do
        if item:getType() == df.item_type.ANVIL and not item.flags.in_building then
            anvil = item
            break
        end
    end
    if anvil then
        local forge = dfhack.buildings.constructBuilding{
            type = df.building_type.Furnace,
            subtype = df.furnace_type.MetalsmithsForge,
            pos = xyz2pos(107, 109, 177),
            width = 3,
            height = 3,
            items = {boulder4, anvil},
        }
        if forge then
            print("Metalsmith's forge built, ID=" .. forge.id)
            dfhack.run_command('build-now')
        end
    else
        print("No anvil available for forge (need to trade for one or smelt iron)")
    end
end

print("\nInfrastructure build complete!")
