-- Build kitchen and butcher with actual boulder items
local function get_free_boulder()
    for _, item in ipairs(df.global.world.items.all) do
        if item:getType() == df.item_type.BOULDER
           and not item.flags.in_building
           and not item.flags.forbid
           and not item.flags.in_job then
            return item
        end
    end
    return nil
end

-- Remove the unbuilt kitchen and butcher first
local to_remove = {}
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld.id == 13 or bld.id == 14 then
        table.insert(to_remove, bld)
    end
end
for _, bld in ipairs(to_remove) do
    dfhack.buildings.deconstruct(bld)
    print("Removed building " .. bld.id)
end

-- Build Kitchen underground with boulder
local boulder1 = get_free_boulder()
if boulder1 then
    local kitchen = dfhack.buildings.constructBuilding{
        type = df.building_type.Workshop,
        subtype = df.workshop_type.Kitchen,
        pos = xyz2pos(95, 109, 177),
        width = 3,
        height = 3,
        items = {boulder1},
    }
    if kitchen then
        print("Kitchen built, ID=" .. kitchen.id)
    end
end

-- Build Butcher underground with boulder
local boulder2 = get_free_boulder()
if boulder2 then
    local butcher = dfhack.buildings.constructBuilding{
        type = df.building_type.Workshop,
        subtype = df.workshop_type.Butchers,
        pos = xyz2pos(99, 109, 177),
        width = 3,
        height = 3,
        items = {boulder2},
    }
    if butcher then
        print("Butcher built, ID=" .. butcher.id)
    end
end

dfhack.run_command('build-now')
print("Done!")
