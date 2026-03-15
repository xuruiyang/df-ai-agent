-- Place beds in the storage area on z95
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

-- Place beds along the edges of z95 storage area
local bed_positions = {}
for y = 82, 98, 2 do
    table.insert(bed_positions, {x=82, y=y})
    table.insert(bed_positions, {x=84, y=y})
    table.insert(bed_positions, {x=106, y=y})
    table.insert(bed_positions, {x=104, y=y})
end

local beds_placed = 0
local bed_idx = 1
for _, pos in ipairs(bed_positions) do
    if bed_idx > #free_beds or bed_idx > 20 then break end
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
