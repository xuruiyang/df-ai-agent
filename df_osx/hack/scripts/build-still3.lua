local function get_boulder()
    for _, item in ipairs(df.global.world.items.all) do
        if item:getType() == df.item_type.BOULDER
           and not item.flags.in_building and not item.flags.forbid
           and not item.flags.in_job and not item.flags.construction then
            return item
        end
    end
end
local stone = get_boulder()
if not stone then print("No boulders!"); return end
local bld = dfhack.buildings.allocInstance(
    xyz2pos(89, 95, 94),
    df.building_type.Workshop, df.workshop_type.Still, -1)
if bld then
    bld.x1 = 88; bld.x2 = 90; bld.y1 = 94; bld.y2 = 96
    bld.centerx = 89; bld.centery = 95
    if dfhack.buildings.constructWithItems(bld, {stone}) then
        print("3rd Still at (88,94,z94)")
    end
end
