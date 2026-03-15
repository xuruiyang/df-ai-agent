-- Place 3 more beds at y=111-113 in bedroom wing
local z = 96
local placed = 0

local beds = {}
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BED
       and not item.flags.in_building
       and not item.flags.forbid
       and not item.flags.in_job then
        table.insert(beds, item)
    end
end

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

for i = 0, 2 do
    local by = 111 + i
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
                placed = placed + 1
            end
        end
    end
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
                -- door placed
            end
        end
    end
end

-- Mark all new beds as rooms
local room_count = 0
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_bedst:is_instance(bld) and not bld.is_room then
        bld.is_room = true
        room_count = room_count + 1
    end
end

print(string.format("Placed %d beds, marked %d new rooms", placed, room_count))
