-- Place tables and chairs in dining hall (x=98-104, y=110-116, z=96)
-- Layout: pairs of table+chair along the room
-- Table on left, chair on right, alternating rows

local z = 96
local placed_tables = 0
local placed_chairs = 0

-- Find available tables
local tables = {}
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.TABLE
       and not item.flags.in_building
       and not item.flags.forbid
       and not item.flags.in_job then
        table.insert(tables, item)
    end
end

-- Find available chairs/thrones
local chairs = {}
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.CHAIR
       and not item.flags.in_building
       and not item.flags.forbid
       and not item.flags.in_job then
        table.insert(chairs, item)
    end
end

print(string.format("Available: %d tables, %d chairs", #tables, #chairs))

-- Place table+chair pairs in dining hall
-- Rows at y=111, 112, 113, 114, 115
-- Tables at x=100, chairs at x=101
local positions = {
    {tx=100, ty=111, cx=101, cy=111},
    {tx=100, ty=113, cx=101, cy=113},
    {tx=100, ty=115, cx=101, cy=115},
    {tx=103, ty=111, cx=102, cy=111},
    {tx=103, ty=113, cx=102, cy=113},
}

for i, pos in ipairs(positions) do
    if i <= #tables then
        local item = tables[i]
        local bld = dfhack.buildings.allocInstance(
            {x=pos.tx, y=pos.ty, z=z},
            df.building_type.Table, -1, -1)
        if bld then
            bld.x1 = pos.tx
            bld.x2 = pos.tx
            bld.y1 = pos.ty
            bld.y2 = pos.ty
            bld.centerx = pos.tx
            bld.centery = pos.ty
            if dfhack.buildings.constructWithItems(bld, {item}) then
                placed_tables = placed_tables + 1
            else
                print(string.format("  Failed table at (%d,%d)", pos.tx, pos.ty))
            end
        end
    end

    if i <= #chairs then
        local item = chairs[i]
        local bld = dfhack.buildings.allocInstance(
            {x=pos.cx, y=pos.cy, z=z},
            df.building_type.Chair, -1, -1)
        if bld then
            bld.x1 = pos.cx
            bld.x2 = pos.cx
            bld.y1 = pos.cy
            bld.y2 = pos.cy
            bld.centerx = pos.cx
            bld.centery = pos.cy
            if dfhack.buildings.constructWithItems(bld, {item}) then
                placed_chairs = placed_chairs + 1
            else
                print(string.format("  Failed chair at (%d,%d)", pos.cx, pos.cy))
            end
        end
    end
end

print(string.format("Placed %d tables and %d chairs in dining hall", placed_tables, placed_chairs))
