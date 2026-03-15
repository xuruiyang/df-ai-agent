-- Workshop, depot, merchant, farm, crafts status
print("=== WORKSHOPS ===")
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) then
        print(string.format("  %s at (%d,%d,z%d) jobs=%d", df.workshop_type[bld.type], bld.centerx, bld.centery, bld.z, #bld.jobs))
    elseif df.building_furnacest:is_instance(bld) then
        print(string.format("  %s at (%d,%d,z%d) jobs=%d", df.furnace_type[bld.type], bld.centerx, bld.centery, bld.z, #bld.jobs))
    end
end

print("\n=== TRADE DEPOT ===")
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.TradeDepot then
        print(string.format("  Depot at (%d,%d,z%d)", bld.x1, bld.y1, bld.z))
        if bld.trade_flags then
            print(string.format("  trader_requested=%s", tostring(bld.trade_flags.trader_requested)))
        end
    end
end

print("\n=== MERCHANTS ===")
local has_merchants = false
for _, unit in ipairs(df.global.world.units.active) do
    if unit.flags1.merchant or unit.flags1.diplomat then
        local name = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
        print(string.format("  %s merchant=%s diplomat=%s", name,
            tostring(unit.flags1.merchant), tostring(unit.flags1.diplomat)))
        has_merchants = true
    end
end
if not has_merchants then print("  No merchants present") end

print("\n=== STONE CRAFTS ===")
local crafts = 0
for _, item in ipairs(df.global.world.items.all) do
    if not item.flags.in_building and not item.flags.forbid and not item.flags.in_job then
        if item:getType() == df.item_type.CRAFTS then crafts = crafts + 1 end
    end
end
print(string.format("  Available crafts: %d", crafts))

print("\n=== FARMS ===")
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.FarmPlot and bld.flags.exists then
        local season = df.global.cur_season
        local plant = bld.plant_id[season]
        local pname = "NONE"
        if plant >= 0 and plant < #df.global.world.raws.plants.all then
            pname = df.global.world.raws.plants.all[plant].id
        end
        print(string.format("  Farm id=%d at (%d,%d) %dx%d plant=%s",
            bld.id, bld.x1, bld.y1, bld.x2-bld.x1+1, bld.y2-bld.y1+1, pname))
    end
end

print("\n=== BREWABLE PLANTS ===")
local brewable = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.PLANT and not item.flags.in_building and not item.flags.forbid and not item.flags.in_job and not item.flags.rotten then
        brewable = brewable + 1
    end
end
print(string.format("  Brewable plants: %d", brewable))

-- Check Urdim specifically
print("\n=== URDIM STATUS ===")
for _, unit in ipairs(df.global.world.units.active) do
    local name = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
    if name:find("Urdim") then
        print(string.format("  %s id=%d mood=%d alive=%s", name, unit.id, unit.mood, tostring(dfhack.units.isAlive(unit))))
        if unit.job.current_job then
            print(string.format("  Current job: %s", tostring(unit.job.current_job.job_type)))
        end
    end
end

-- Dead/missing dwarves
print("\n=== DEAD CITIZENS ===")
for _, unit in ipairs(df.global.world.units.all) do
    if dfhack.units.isCitizen(unit) and not dfhack.units.isAlive(unit) then
        local name = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
        print(string.format("  %s id=%d", name, unit.id))
    end
end
