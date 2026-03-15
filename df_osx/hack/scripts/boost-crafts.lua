-- Check craft workshop status and boost crafters
-- Check workshop at z93
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) and bld.type == df.workshop_type.Craftsdwarfs then
        print(string.format("Craftsdwarfs at (%d,%d,z%d) jobs=%d exists=%s",
            bld.centerx, bld.centery, bld.z, #bld.jobs, tostring(bld.flags.exists)))
    end
end

-- Count stone crafters
local crafters = 0
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit) and unit.mood < 0 then
        if unit.status.labors[df.unit_labor.STONE_CRAFT] then
            crafters = crafters + 1
        end
    end
end
print(string.format("Stone crafters: %d", crafters))

-- Enable on more dwarves if needed
if crafters < 6 then
    local needed = 6 - crafters
    local added = 0
    for _, unit in ipairs(df.global.world.units.active) do
        if dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit) and unit.mood < 0 then
            if not unit.status.labors[df.unit_labor.STONE_CRAFT] then
                unit.status.labors[df.unit_labor.STONE_CRAFT] = true
                added = added + 1
                local name = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
                print(string.format("  Enabled STONE_CRAFT on %s", name))
                if added >= needed then break end
            end
        end
    end
end

-- Also enable more miners for z91
local miners = 0
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit) and unit.mood < 0 then
        if unit.status.labors[df.unit_labor.MINE] then
            miners = miners + 1
        end
    end
end
print(string.format("Miners: %d", miners))
if miners < 5 then
    local needed = 5 - miners
    local added = 0
    for _, unit in ipairs(df.global.world.units.active) do
        if dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit) and unit.mood < 0 then
            if not unit.status.labors[df.unit_labor.MINE] then
                unit.status.labors[df.unit_labor.MINE] = true
                added = added + 1
                if added >= needed then break end
            end
        end
    end
    print(string.format("Enabled MINE on %d more dwarves", added))
end

-- Enable more brewers
local brewers = 0
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit) and unit.mood < 0 then
        if unit.status.labors[df.unit_labor.BREWER] then
            brewers = brewers + 1
        end
    end
end
print(string.format("Brewers: %d", brewers))
if brewers < 5 then
    local needed = 5 - brewers
    local added = 0
    for _, unit in ipairs(df.global.world.units.active) do
        if dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit) and unit.mood < 0 then
            if not unit.status.labors[df.unit_labor.BREWER] then
                unit.status.labors[df.unit_labor.BREWER] = true
                added = added + 1
                if added >= needed then break end
            end
        end
    end
    print(string.format("Enabled BREWER on %d more dwarves", added))
end
