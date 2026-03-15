-- Create boulders and build workshops
-- First find a unit to associate items with
local unit = df.global.world.units.active[0]

-- Create boulders using the correct argument format
dfhack.run_command('modtools/create-item', '-item', 'BOULDER:NONE', '-material', 'INORGANIC:GRANITE', '-unit', tostring(unit.id))
dfhack.run_command('modtools/create-item', '-item', 'BOULDER:NONE', '-material', 'INORGANIC:GRANITE', '-unit', tostring(unit.id))
dfhack.run_command('modtools/create-item', '-item', 'BOULDER:NONE', '-material', 'INORGANIC:GRANITE', '-unit', tostring(unit.id))
dfhack.run_command('modtools/create-item', '-item', 'BOULDER:NONE', '-material', 'INORGANIC:GRANITE', '-unit', tostring(unit.id))
dfhack.run_command('modtools/create-item', '-item', 'BOULDER:NONE', '-material', 'INORGANIC:GRANITE', '-unit', tostring(unit.id))

-- Find free boulders
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

local function build_workshop(wtype, x, y, z, name)
    local boulder = get_free_boulder()
    if not boulder then
        print("No boulder for " .. name)
        return
    end

    local bld = dfhack.buildings.constructBuilding{
        type = df.building_type.Workshop,
        subtype = wtype,
        pos = xyz2pos(x, y, z),
        width = 3,
        height = 3,
        items = {boulder},
    }
    if bld then
        print(name .. " built, ID=" .. bld.id)
    else
        print("Failed: " .. name)
    end
end

build_workshop(df.workshop_type.Carpenters, 105, 98, 178, "Carpenter")
build_workshop(df.workshop_type.Still, 109, 95, 178, "Still")
build_workshop(df.workshop_type.Masons, 105, 102, 178, "Mason")
build_workshop(df.workshop_type.Craftsdwarfs, 109, 99, 178, "Crafts")

dfhack.run_command('build-now')

-- Report
local bs = df.global.world.buildings.all
print("\nBuildings:")
for i = 0, #bs - 1 do
    local b = bs[i]
    print(string.format("  %s (ID=%d) exists=%s", df.building_type[b:getType()], b.id, tostring(b.flags.exists)))
end
