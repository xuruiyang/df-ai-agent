-- Place beds on z95 in the actual dug-out area
local free_beds = {}
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BED and not item.flags.in_building and not item.flags.forbid and not item.flags.in_job then
        table.insert(free_beds, item)
    end
end
print(string.format("Free beds: %d", #free_beds))

local function is_floor_empty(x, y, z)
    local block = dfhack.maps.getTileBlock(x, y, z)
    if not block then return false end
    local lx = x % 16
    local ly = y % 16
    local tt = block.tiletype[lx][ly]
    local shape = df.tiletype.attrs[tt].shape
    if shape ~= df.tiletype_shape.FLOOR then return false end
    local occ = block.occupancy[lx][ly]
    if occ.building ~= 0 then return false end
    return true
end

-- Place beds along edges of z95 area (x=84-103, y=80-110)
-- Use perimeter positions, spaced out
local bed_positions = {}
-- Along left wall (x=85)
for y = 82, 108, 2 do
    table.insert(bed_positions, {x=85, y=y})
end
-- Along right wall (x=102)
for y = 82, 108, 2 do
    table.insert(bed_positions, {x=102, y=y})
end

local beds_placed = 0
local bed_idx = 1
for _, pos in ipairs(bed_positions) do
    if bed_idx > #free_beds or beds_placed >= 17 then break end
    if is_floor_empty(pos.x, pos.y, 95) then
        local bed = free_beds[bed_idx]
        local bpos = xyz2pos(pos.x, pos.y, 95)
        local bld = dfhack.buildings.allocInstance(bpos, df.building_type.Bed, -1, -1)
        if bld then
            local ok = pcall(function()
                dfhack.buildings.constructWithItems(bld, {bed})
            end)
            if ok then
                beds_placed = beds_placed + 1
                bed_idx = bed_idx + 1
            end
        end
    end
end
print(string.format("Placed %d beds on z95", beds_placed))

-- Make all beds into rooms
print("Making new beds into rooms...")
local rooms_made = 0
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.Bed and bld.z == 95 then
        if not bld.is_room then
            bld.is_room = true
            rooms_made = rooms_made + 1
        end
    end
end
print(string.format("Made %d beds into rooms", rooms_made))
