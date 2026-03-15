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

local bld = dfhack.buildings.allocInstance(
    xyz2pos(93, 91, 94),
    df.building_type.Workshop, df.workshop_type.Carpenters, -1)
if bld then
    bld.x1 = 92; bld.x2 = 94; bld.y1 = 90; bld.y2 = 92
    bld.centerx = 93; bld.centery = 91
    if dfhack.buildings.constructWithItems(bld, {stone}) then
        print("2nd Carpenters workshop at (92,90,z94)")
    else
        print("Failed to build")
    end
end
