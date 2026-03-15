-- Place beds and doors in the expanded bedroom wing
-- New rooms at x=104-106, y=104-110, z=96
-- Bed at x=105, door at x=104 (hallway side)
local z = 96
local placed_beds = 0
local placed_doors = 0

-- Find available beds
local beds = {}
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BED
       and not item.flags.in_building
       and not item.flags.forbid
       and not item.flags.in_job then
        table.insert(beds, item)
    end
end

-- Find available doors
local doors = {}
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.DOOR
       and not item.flags.in_building
       and not item.flags.forbid
       and not item.flags.in_job then
        table.insert(doors, item)
    end
end

print(string.format("Available: %d beds, %d doors", #beds, #doors))

-- Place beds at y=104 to y=110 (7 more rooms)
for i = 0, 6 do
    local by = 104 + i
    -- Place bed
    if i < #beds then
        local item = beds[i+1]
        local bld = dfhack.buildings.allocInstance(
            {x=105, y=by, z=z},
            df.building_type.Bed, -1, -1)
        if bld then
            bld.x1 = 105; bld.x2 = 105
            bld.y1 = by; bld.y2 = by
            bld.centerx = 105; bld.centery = by
            if dfhack.buildings.constructWithItems(bld, {item}) then
                placed_beds = placed_beds + 1
            end
        end
    end

    -- Place door at hallway entrance
    if i < #doors then
        local item = doors[i+1]
        local bld = dfhack.buildings.allocInstance(
            {x=104, y=by, z=z},
            df.building_type.Door, -1, -1)
        if bld then
            bld.x1 = 104; bld.x2 = 104
            bld.y1 = by; bld.y2 = by
            bld.centerx = 104; bld.centery = by
            if dfhack.buildings.constructWithItems(bld, {item}) then
                placed_doors = placed_doors + 1
            end
        end
    end
end

print(string.format("Placed %d beds and %d doors in new bedroom wing", placed_beds, placed_doors))

-- Mark new beds as rooms
local count = 0
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_bedst:is_instance(bld) and not bld.is_room then
        bld.is_room = true
        count = count + 1
    end
end
print(string.format("Marked %d new beds as rooms", count))
