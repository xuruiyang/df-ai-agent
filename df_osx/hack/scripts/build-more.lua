local function build_workshop(workshop_type, x, y, z)
    local subtype = df.workshop_type[workshop_type]
    local pos = xyz2pos(x, y, z)
    local bld = dfhack.buildings.allocInstance(pos, df.building_type.Workshop, subtype, -1)
    if not bld then return false end
    local filter = df.job_item:new()
    filter.item_type = df.item_type.BOULDER
    filter.quantity = 1
    filter.vector_id = df.job_item_vector_id.BOULDER
    filter.flags2.building_material = true
    filter.flags2.non_economic = true
    local ok = pcall(function() dfhack.buildings.constructWithFilters(bld, {filter}) end)
    if ok then
        print(string.format("Placed %s at (%d,%d,%d)", workshop_type, x, y, z))
    else
        print(string.format("Failed %s", workshop_type))
    end
    return ok
end

-- More workshops
build_workshop("Craftsdwarfs", 94, 105, 96)
build_workshop("Kitchen", 94, 108, 96)
build_workshop("Butchers", 88, 111, 96)

-- Build farm plot (3x3 subterranean)
local function build_farm(x, y, z, w, h)
    local pos = xyz2pos(x, y, z)
    local bld = dfhack.buildings.allocInstance(pos, df.building_type.FarmPlot, -1, -1)
    if not bld then
        print("Failed to allocate farm plot")
        return false
    end
    bld.x1 = x
    bld.x2 = x + w - 1
    bld.y1 = y
    bld.y2 = y + h - 1
    
    local ok = pcall(function() dfhack.buildings.constructAbstract(bld) end)
    if ok then
        print(string.format("Placed farm plot at (%d,%d,%d) %dx%d id=%d", x, y, z, w, h, bld.id))
    else
        print("Failed to place farm plot")
    end
    return ok
end

-- Farm plots in the farm area (north of corridor)
build_farm(86, 90, 96, 4, 4)
build_farm(86, 94, 96, 4, 4)
