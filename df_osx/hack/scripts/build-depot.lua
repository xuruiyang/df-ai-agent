-- Build a trade depot on the surface using constructWithItems
local x, y, z = 84, 98, 97

-- Find 3 non-economic boulders
local boulders = {}
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BOULDER
       and not item.flags.in_building
       and not item.flags.forbid
       and not item.flags.in_job
       and not item.flags.construction then
        -- Check it's non-economic (not a gem-bearing stone)
        table.insert(boulders, item)
        if #boulders >= 3 then break end
    end
end

if #boulders < 3 then
    print(string.format("Need 3 boulders, only found %d", #boulders))
    return
end

print(string.format("Found %d boulders for depot", #boulders))

local bld = dfhack.buildings.allocInstance(
    {x=x+2, y=y+2, z=z},
    df.building_type.TradeDepot, -1, -1)

if not bld then
    print("Failed to allocate trade depot")
    return
end

bld.x1 = x
bld.x2 = x + 4
bld.y1 = y
bld.y2 = y + 4
bld.centerx = x + 2
bld.centery = y + 2

local ok = dfhack.buildings.constructWithItems(bld, boulders)
if ok then
    print(string.format("Trade depot placed at (%d,%d,%d)", x, y, z))
else
    print("Failed to construct trade depot with items")
end
