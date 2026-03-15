local function get_boulder()
    for _, item in ipairs(df.global.world.items.all) do
        if item:getType() == df.item_type.BOULDER
           and not item.flags.in_building
           and not item.flags.forbid
           and not item.flags.in_job
           and not item.flags.construction then
            return item
        end
    end
end

local stone = get_boulder()
if not stone then print("No boulders!"); return end

-- Build Glass Furnace on z94
local bld = dfhack.buildings.allocInstance(
    xyz2pos(93, 95, 94),
    df.building_type.Furnace, df.furnace_type.GlassFurnace, -1)
if bld then
    bld.x1 = 92; bld.x2 = 94; bld.y1 = 94; bld.y2 = 96
    bld.centerx = 93; bld.centery = 95
    if dfhack.buildings.constructWithItems(bld, {stone}) then
        print("Glass Furnace placed at (92,94,z94)!")
    else
        print("Failed to construct")
    end
else
    print("Failed to allocate")
end
