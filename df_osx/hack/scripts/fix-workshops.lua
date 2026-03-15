-- Remove all incorrectly-sized workshops
local to_remove = {}
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.Workshop then
        table.insert(to_remove, bld)
    end
end
for _, bld in ipairs(to_remove) do
    print(string.format("Removing workshop id=%d", bld.id))
    dfhack.buildings.deconstruct(bld)
end

-- Rebuild workshops with proper 3x3 dimensions
local function build_workshop(workshop_type, cx, cy, z)
    local subtype = df.workshop_type[workshop_type]
    local pos = xyz2pos(cx, cy, z)
    local bld = dfhack.buildings.allocInstance(pos, df.building_type.Workshop, subtype, -1)
    if not bld then
        print("Failed to allocate " .. workshop_type)
        return
    end
    
    -- Set proper 3x3 dimensions centered on cx,cy
    bld.x1 = cx - 1; bld.x2 = cx + 1
    bld.y1 = cy - 1; bld.y2 = cy + 1
    bld.centerx = cx; bld.centery = cy
    
    local filter = df.job_item:new()
    filter.item_type = df.item_type.BOULDER
    filter.quantity = 1
    filter.vector_id = df.job_item_vector_id.BOULDER
    filter.flags2.building_material = true
    filter.flags2.non_economic = true
    
    local ok, err = pcall(function() return dfhack.buildings.constructWithFilters(bld, {filter}) end)
    if ok then
        print(string.format("Built %s at (%d,%d,%d) dims (%d,%d)-(%d,%d)", 
            workshop_type, cx, cy, z, bld.x1, bld.y1, bld.x2, bld.y2))
    else
        print(string.format("Failed %s: %s", workshop_type, tostring(err)))
    end
end

-- Place workshops in workshop area (z96, south of corridor)
-- Need to check for pillars and use clear 3x3 areas
-- Workshop area is roughly (86-96, 103-113)
build_workshop("Still", 88, 105, 96)
build_workshop("Carpenters", 88, 108, 96)
build_workshop("Masons", 92, 105, 96)
build_workshop("Craftsdwarfs", 92, 108, 96)
build_workshop("Kitchen", 95, 108, 96)
build_workshop("Butchers", 88, 112, 96)
