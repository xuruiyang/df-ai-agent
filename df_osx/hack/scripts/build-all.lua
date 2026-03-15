local EX = 94  -- entrance x
local EY = 100 -- entrance y

-- === VERIFY STAIRWAY ===
for z = 96, 97 do
    local b = dfhack.maps.getTileBlock(EX, EY, z)
    if b then
        local tt = b.tiletype[EX%16][EY%16]
        local shape = df.tiletype_shape[df.tiletype.attrs[tt].shape] or "?"
        print(string.format("Stair check z%d: shape=%s", z, shape))
    end
end

-- === BUILD WORKSHOPS (with proper 3x3 dims) ===
local function build_ws(ws_type, cx, cy, z)
    local subtype = df.workshop_type[ws_type]
    local pos = xyz2pos(cx, cy, z)
    local bld = dfhack.buildings.allocInstance(pos, df.building_type.Workshop, subtype, -1)
    if not bld then print("Failed to alloc " .. ws_type); return nil end
    bld.x1 = cx-1; bld.x2 = cx+1; bld.y1 = cy-1; bld.y2 = cy+1
    bld.centerx = cx; bld.centery = cy
    local filter = df.job_item:new()
    filter.item_type = df.item_type.BOULDER
    filter.quantity = 1
    filter.vector_id = df.job_item_vector_id.BOULDER
    filter.flags2.building_material = true
    filter.flags2.non_economic = true
    local ok = pcall(function() dfhack.buildings.constructWithFilters(bld, {filter}) end)
    if ok then
        print(string.format("Placed %s at (%d,%d,%d) id=%d", ws_type, cx, cy, z, bld.id))
        return bld
    else
        print(string.format("FAILED %s at (%d,%d)", ws_type, cx, cy))
        return nil
    end
end

-- Workshop area starts at (EX-4, EY+3, 96) = (90, 103, 96)
-- Place workshops with safe spacing
build_ws("Still", EX-3, EY+5, 96)       -- (91, 105)
build_ws("Carpenters", EX-3, EY+8, 96)  -- (91, 108)
build_ws("Masons", EX+1, EY+5, 96)      -- (95, 105)
build_ws("Craftsdwarfs", EX+1, EY+8, 96) -- (95, 108)
build_ws("Kitchen", EX+5, EY+5, 96)     -- (99, 105)
build_ws("Butchers", EX-3, EY+11, 96)   -- (91, 111)

-- === ALSO BUILD SURFACE STILL (near supplies for fast brewing) ===
build_ws("Still", EX+4, EY-3, 97)       -- surface still at (98, 97)
build_ws("Carpenters", EX+4, EY+3, 97)  -- surface carpenter at (98, 103)

-- === BUILD FARM PLOTS ===
local function build_farm(x1, y1, x2, y2, z)
    local pos = xyz2pos(x1, y1, z)
    local bld = dfhack.buildings.allocInstance(pos, df.building_type.FarmPlot, -1, -1)
    if not bld then print("Failed farm alloc"); return end
    bld.x1 = x1; bld.x2 = x2; bld.y1 = y1; bld.y2 = y2
    local ok = pcall(function() dfhack.buildings.constructWithFilters(bld, {}) end)
    if ok then
        print(string.format("Farm at (%d,%d)-(%d,%d) z%d id=%d", x1,y1,x2,y2,z, bld.id))
    else
        print("Farm FAILED")
    end
end

-- Farm area: (EX-5, EY-12) = (89, 88)
build_farm(EX-5, EY-12, EX-2, EY-9, 96) -- 4x4 farm
build_farm(EX-5, EY-8, EX-2, EY-5, 96)  -- 4x4 farm

-- === SET UP PLUMP HELMETS ===
-- Find plump helmet plant index
local plump_id = -1
for i, plant in ipairs(df.global.world.raws.plants.all) do
    if plant.id == "MUSHROOM_HELMET_PLUMP" then
        plump_id = i
        break
    end
end

if plump_id >= 0 then
    for _, bld in ipairs(df.global.world.buildings.all) do
        if bld:getType() == df.building_type.FarmPlot and bld.flags.exists then
            for season = 0, 3 do
                bld.plant_id[season] = plump_id
            end
            print("Set plump helmets on farm id=" .. bld.id)
        end
    end
end

print("\n=== BUILD PHASE COMPLETE ===")
