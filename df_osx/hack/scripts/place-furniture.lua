local EX, EY = 94, 100
local bed_hallway_x = EX + 9  -- 103

-- Place beds at (104, EY-3 to EY+3, z96)
local beds_placed = 0
local doors_placed = 0

for offset = -3, 3 do
    local bx, by = 104, EY + offset
    
    -- Check tile is floor
    local block = dfhack.maps.getTileBlock(bx, by, 96)
    if not block then goto next end
    local shape = df.tiletype_shape[df.tiletype.attrs[block.tiletype[bx%16][by%16]].shape] or "?"
    if shape ~= "FLOOR" then goto next end
    
    -- Find an uninstalled bed
    local bed_item = nil
    for _, item in ipairs(df.global.world.items.all) do
        if item:getType() == df.item_type.BED and item.pos.x > 0 and 
           not item.flags.in_building and not item.flags.in_job then
            bed_item = item
            break
        end
    end
    
    if bed_item then
        local pos = xyz2pos(bx, by, 96)
        local bld = dfhack.buildings.allocInstance(pos, df.building_type.Bed, -1, -1)
        if bld then
            local ok = pcall(function() dfhack.buildings.constructWithItems(bld, {bed_item}) end)
            if ok then
                beds_placed = beds_placed + 1
            end
        end
    end
    
    -- Place door at hallway entrance (103, by)
    local dx = bed_hallway_x
    block = dfhack.maps.getTileBlock(dx, by, 96)
    if block then
        shape = df.tiletype_shape[df.tiletype.attrs[block.tiletype[dx%16][by%16]].shape] or "?"
        if shape == "FLOOR" then
            local door_item = nil
            for _, item in ipairs(df.global.world.items.all) do
                if item:getType() == df.item_type.DOOR and item.pos.x > 0 and
                   not item.flags.in_building and not item.flags.in_job then
                    door_item = item
                    break
                end
            end
            if door_item then
                local pos = xyz2pos(dx, by, 96)
                local bld = dfhack.buildings.allocInstance(pos, df.building_type.Door, -1, -1)
                if bld then
                    local ok = pcall(function() dfhack.buildings.constructWithItems(bld, {door_item}) end)
                    if ok then doors_placed = doors_placed + 1 end
                end
            end
        end
    end
    
    ::next::
end

print(string.format("Placed %d beds and %d doors in bedrooms", beds_placed, doors_placed))

-- Also place tables and chairs for dining area
-- Use the corridor area near workshops
local table_item, chair_item
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.TABLE and item.pos.x > 0 and 
       not item.flags.in_building and not item.flags.in_job and not table_item then
        table_item = item
    end
    if item:getType() == df.item_type.CHAIR and item.pos.x > 0 and
       not item.flags.in_building and not item.flags.in_job and not chair_item then
        chair_item = item
    end
end

if table_item and chair_item then
    -- Place in corridor area
    local tx, ty = EX-2, EY+2
    local pos = xyz2pos(tx, ty, 96)
    local tbld = dfhack.buildings.allocInstance(pos, df.building_type.Table, -1, -1)
    if tbld then
        pcall(function() dfhack.buildings.constructWithItems(tbld, {table_item}) end)
    end
    local pos2 = xyz2pos(tx+1, ty, 96)
    local cbld = dfhack.buildings.allocInstance(pos2, df.building_type.Chair, -1, -1)
    if cbld then
        pcall(function() dfhack.buildings.constructWithItems(cbld, {chair_item}) end)
    end
    print("Placed table + chair for dining")
end
