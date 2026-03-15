-- Build a Still on the surface near the wagon/supplies
-- Wagon is at (89,100,97), supplies should be nearby
local pos = xyz2pos(94, 98, 97)
local bld = dfhack.buildings.allocInstance(pos, df.building_type.Workshop, df.workshop_type.Still, -1)
if bld then
    bld.x1 = 93; bld.x2 = 95; bld.y1 = 97; bld.y2 = 99
    bld.centerx = 94; bld.centery = 98
    
    -- Use wood for construction (we have plenty)
    local filter = df.job_item:new()
    filter.item_type = df.item_type.BOULDER
    filter.quantity = 1
    filter.vector_id = df.job_item_vector_id.BOULDER
    filter.flags2.building_material = true
    filter.flags2.non_economic = true
    
    local ok = pcall(function() dfhack.buildings.constructWithFilters(bld, {filter}) end)
    if ok then
        print("Placed surface Still at (94,98,97)! Waiting for construction...")
    else
        print("Failed to place surface Still")
    end
end

-- Also build a surface Carpenter's workshop 
local pos2 = xyz2pos(98, 98, 97)
local bld2 = dfhack.buildings.allocInstance(pos2, df.building_type.Workshop, df.workshop_type.Carpenters, -1)
if bld2 then
    bld2.x1 = 97; bld2.x2 = 99; bld2.y1 = 97; bld2.y2 = 99
    bld2.centerx = 98; bld2.centery = 98
    local filter2 = df.job_item:new()
    filter2.item_type = df.item_type.BOULDER
    filter2.quantity = 1
    filter2.vector_id = df.job_item_vector_id.BOULDER
    filter2.flags2.building_material = true
    filter2.flags2.non_economic = true
    local ok2 = pcall(function() dfhack.buildings.constructWithFilters(bld2, {filter2}) end)
    if ok2 then
        print("Placed surface Carpenter's at (98,98,97)!")
    end
end
