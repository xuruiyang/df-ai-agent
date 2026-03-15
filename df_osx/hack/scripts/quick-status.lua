-- Quick status check
local drinks = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.DRINK and not item.flags.forbid then
        drinks = drinks + item.stack_size
    end
end

local crafts = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.CRAFTS and not item.flags.in_building and not item.flags.forbid and not item.flags.in_job then
        crafts = crafts + 1
    end
end

local barrels = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BARREL and not item.flags.in_building and not item.flags.forbid and not item.flags.in_job then
        barrels = barrels + 1
    end
end

-- Urdim status
local urdim = df.unit.find(19100)
local urdim_status = "not found"
if urdim then
    if dfhack.units.isAlive(urdim) then
        urdim_status = string.format("alive at (%d,%d,z%d)", urdim.pos.x, urdim.pos.y, urdim.pos.z)
    else
        urdim_status = "DEAD"
    end
end

-- Check dead/missing
local dead = 0
for _, unit in ipairs(df.global.world.units.all) do
    if dfhack.units.isCitizen(unit) and not dfhack.units.isAlive(unit) then
        dead = dead + 1
        local name = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
        print(string.format("  Dead: %s id=%d", name, unit.id))
    end
end

print(string.format("Drinks=%d Crafts=%d Barrels=%d Urdim=%s Dead=%d", drinks, crafts, barrels, urdim_status, dead))

-- Workshop jobs summary
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) then
        local name = df.workshop_type[bld.type]
        if name == "Craftsdwarfs" or name == "Still" then
            print(string.format("  %s (%d,%d,z%d) jobs=%d", name, bld.centerx, bld.centery, bld.z, #bld.jobs))
        end
    end
end
