local z = 96
local placed_beds = 0
local placed_doors = 0

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

for i = 0, 7 do
    local by = 114 + i
    if i < #beds then
        local bld = dfhack.buildings.allocInstance(
            xyz2pos(105, by, z),
            df.building_type.Bed, -1, -1)
        if bld then
            bld.x1 = 105; bld.x2 = 105; bld.y1 = by; bld.y2 = by
            bld.centerx = 105; bld.centery = by
            if dfhack.buildings.constructWithItems(bld, {beds[i+1]}) then
                placed_beds = placed_beds + 1
            end
        end
    end
    if i < #doors then
        local bld = dfhack.buildings.allocInstance(
            xyz2pos(104, by, z),
            df.building_type.Door, -1, -1)
        if bld then
            bld.x1 = 104; bld.x2 = 104; bld.y1 = by; bld.y2 = by
            bld.centerx = 104; bld.centery = by
            if dfhack.buildings.constructWithItems(bld, {doors[i+1]}) then
                placed_doors = placed_doors + 1
            end
        end
    end
end

-- Mark new beds as rooms
local rc = 0
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_bedst:is_instance(bld) and not bld.is_room then
        bld.is_room = true; rc = rc + 1
    end
end

print(string.format("Placed %d beds, %d doors, marked %d rooms", placed_beds, placed_doors, rc))
