local function build_workshop(workshop_type, x, y, z)
    local subtype = df.workshop_type[workshop_type]
    if not subtype then
        print("Unknown workshop type: " .. workshop_type)
        return false
    end
    
    local pos = xyz2pos(x, y, z)
    local bld = dfhack.buildings.allocInstance(pos, df.building_type.Workshop, subtype, -1)
    if not bld then
        print("Failed to allocate " .. workshop_type)
        return false
    end
    
    -- Create job_item filter for building materials
    local filter = df.job_item:new()
    filter.item_type = df.item_type.BOULDER  -- stone
    filter.quantity = 1
    filter.vector_id = df.job_item_vector_id.BOULDER
    filter.flags2.building_material = true
    filter.flags2.non_economic = true
    
    local ok, err = pcall(function()
        return dfhack.buildings.constructWithFilters(bld, {filter})
    end)
    if ok then
        print(string.format("Placed %s at (%d,%d,%d) id=%d", workshop_type, x, y, z, bld.id))
        return true
    else
        print(string.format("Failed %s: %s", workshop_type, tostring(err)))
        -- Try alternate: wood instead of stone
        local bld2 = dfhack.buildings.allocInstance(pos, df.building_type.Workshop, subtype, -1)
        local filter2 = df.job_item:new()
        filter2.item_type = df.item_type.WOOD
        filter2.quantity = 1
        filter2.vector_id = df.job_item_vector_id.WOOD
        local ok2, err2 = pcall(function()
            return dfhack.buildings.constructWithFilters(bld2, {filter2})
        end)
        if ok2 then
            print(string.format("Placed %s (wood) at (%d,%d,%d) id=%d", workshop_type, x, y, z, bld2.id))
            return true
        else
            print(string.format("Also failed with wood: %s", tostring(err2)))
            return false
        end
    end
end

build_workshop("Still", 88, 105, 96)
build_workshop("Carpenters", 88, 108, 96)
build_workshop("Masons", 91, 105, 96)
