-- Expand farm capacity: build 4 more farm plots on z96
-- Current farms at (89,88), (89,92), (93,88), (93,92) — all 4x4
-- New farms: (85,88), (85,92), (97,88), (97,92)

local plump_id = -1
for i, plant in ipairs(df.global.world.raws.plants.all) do
    if plant.id == "MUSHROOM_HELMET_PLUMP" then plump_id = i; break end
end

local function build_farm(x1, y1, x2, y2, z)
    -- Check if tiles are floor
    local block = dfhack.maps.getTileBlock(x1, y1, z)
    if not block then print(string.format("No block at (%d,%d,z%d)", x1, y1, z)); return nil end
    local lx = x1 % 16
    local ly = y1 % 16
    local tt = block.tiletype[lx][ly]
    local shape = df.tiletype.attrs[tt].shape
    if shape ~= df.tiletype_shape.FLOOR then
        print(string.format("Not floor at (%d,%d,z%d): %s — need to dig", x1, y1, z, tostring(shape)))
        -- Designate for digging
        for x = x1, x2 do
            for y = y1, y2 do
                local b = dfhack.maps.getTileBlock(x, y, z)
                if b then
                    local lx2 = x % 16
                    local ly2 = y % 16
                    local tt2 = b.tiletype[lx2][ly2]
                    if df.tiletype.attrs[tt2].shape == df.tiletype_shape.WALL then
                        b.designation[lx2][ly2].dig = df.tile_dig_designation.Default
                        b.flags.designated = true
                    end
                end
            end
        end
        return nil
    end
    
    local pos = xyz2pos(x1, y1, z)
    local bld = dfhack.buildings.allocInstance(pos, df.building_type.FarmPlot, -1, -1)
    if not bld then print("Failed farm alloc"); return nil end
    bld.x1 = x1; bld.x2 = x2; bld.y1 = y1; bld.y2 = y2
    local ok = pcall(function() dfhack.buildings.constructWithFilters(bld, {}) end)
    if ok then
        -- Set plump helmets
        for season = 0, 3 do
            bld.plant_id[season] = plump_id
        end
        print(string.format("Farm at (%d,%d)-(%d,%d) z%d id=%d", x1,y1,x2,y2,z, bld.id))
        return bld
    else
        print("Farm build FAILED")
        return nil
    end
end

print("=== BUILDING NEW FARMS ===")
build_farm(85, 88, 88, 91, 96)  -- Farm 5 (west of existing)
build_farm(85, 92, 88, 95, 96)  -- Farm 6
build_farm(97, 88, 100, 91, 96)  -- Farm 7 (east of existing)
build_farm(97, 92, 100, 95, 96)  -- Farm 8

-- Also check for other brewable underground plants
print("\n=== UNDERGROUND BREWABLE PLANTS ===")
for i, plant in ipairs(df.global.world.raws.plants.all) do
    if plant.flags.BIOME_SUBTERRANEAN_WATER then
        local drink_name = "?"
        for _, mat in ipairs(plant.material) do
            if mat.id == "DRINK" then
                drink_name = mat.state_name.Liquid
            end
        end
        print(string.format("  %s -> %s", plant.id, drink_name))
    end
end
