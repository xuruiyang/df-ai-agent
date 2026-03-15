-- Force-build a trade depot and workshops by creating items and using them
local utils = require('utils')

-- First, create some boulder items for construction
print("Creating construction materials...")
dfhack.run_command('modtools/create-item', '-item', 'BOULDER:NONE', '-material', 'INORGITE:ITE_GRANITE', '-count', '20', '-unit', tostring(df.global.world.units.active[0].id))

print("Materials created. Now attempting to build...")

-- Helper to build a workshop
local function build_workshop(wtype, x, y, z, name)
    -- Find available boulder items nearby
    local items = {}
    for _, item in ipairs(df.global.world.items.all) do
        if item:getType() == df.item_type.BOULDER and not item.flags.in_building and not item.flags.forbid then
            table.insert(items, item)
            if #items >= 1 then break end
        end
    end

    if #items < 1 then
        print("No free boulders for " .. name)
        return nil
    end

    local bld = dfhack.buildings.constructBuilding{
        type = df.building_type.Workshop,
        subtype = wtype,
        pos = xyz2pos(x, y, z),
        width = 3,
        height = 3,
        items = items,
    }
    if bld then
        print(name .. " placed, ID=" .. bld.id)
        return bld
    else
        print("Failed to place " .. name)
        return nil
    end
end

-- Helper to build trade depot
local function build_depot(x, y, z)
    local items = {}
    for _, item in ipairs(df.global.world.items.all) do
        if item:getType() == df.item_type.BOULDER and not item.flags.in_building and not item.flags.forbid then
            table.insert(items, item)
            if #items >= 3 then break end
        end
    end

    if #items < 3 then
        print("Not enough free boulders for trade depot (need 3, have " .. #items .. ")")
        return nil
    end

    local bld = dfhack.buildings.constructBuilding{
        type = df.building_type.TradeDepot,
        pos = xyz2pos(x, y, z),
        width = 5,
        height = 5,
        items = items,
    }
    if bld then
        print("Trade depot placed, ID=" .. bld.id)
        return bld
    else
        print("Failed to place trade depot")
        return nil
    end
end

-- Build trade depot first (most urgent - caravan waiting!)
build_depot(94, 98, 178)

-- Build workshops
build_workshop(df.workshop_type.Carpenters, 105, 98, 178, "Carpenter")
build_workshop(df.workshop_type.Masons, 105, 102, 178, "Mason")
build_workshop(df.workshop_type.Still, 109, 95, 178, "Still")
build_workshop(df.workshop_type.Craftsdwarfs, 109, 99, 178, "Crafts")

print("\nRunning build-now to complete construction...")
dfhack.run_command('build-now')

print("Done! Checking buildings...")
local bs = df.global.world.buildings.all
print("Total buildings: " .. #bs)
for i = 0, #bs - 1 do
    local b = bs[i]
    print(string.format("  ID=%d type=%s exists=%s", b.id, df.building_type[b:getType()], tostring(b.flags.exists)))
end
