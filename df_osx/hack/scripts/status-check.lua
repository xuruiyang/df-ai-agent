-- Comprehensive status check
print("=== DRINKS ===")
local drinks = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.DRINK and not item.flags.forbid and not item.flags.dump and not item.flags.in_building then
        drinks = drinks + item.stack_size
    end
end
print(string.format("  Actual drinks: %d", drinks))

print("\n=== BARRELS ===")
local barrels_free = 0
local barrels_total = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BARREL then
        barrels_total = barrels_total + 1
        if not item.flags.in_building and not item.flags.in_job and not item.flags.forbid then
            barrels_free = barrels_free + 1
        end
    end
end
print(string.format("  Total barrels: %d, Free: %d", barrels_total, barrels_free))

print("\n=== MOODS ===")
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) and unit.mood >= 0 then
        local name = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
        print(string.format("  %s mood=%d job=%s", name, unit.mood,
            unit.job.current_job and tostring(unit.job.current_job.job_type) or "none"))
    end
end

print("\n=== WORKSHOPS ===")
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) or df.building_furnacest:is_instance(bld) then
        local jobs = #bld.jobs
        local name = df.building_type.attrs[bld:getType()].caption or "?"
        if df.building_workshopst:is_instance(bld) then
            name = df.workshop_type[bld.type]
        elseif df.building_furnacest:is_instance(bld) then
            name = df.furnace_type[bld.type]
        end
        print(string.format("  %s at (%d,%d,z%d) jobs=%d", name, bld.centerx, bld.centery, bld.z, jobs))
    end
end

print("\n=== TRADE DEPOT ===")
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.TradeDepot then
        print(string.format("  Depot at (%d,%d,z%d) id=%d", bld.x1, bld.y1, bld.z, bld.id))
        if bld.trade_flags then
            print(string.format("  trader_requested=%s", tostring(bld.trade_flags.trader_requested)))
        end
    end
end

-- Merchants present?
print("\n=== MERCHANTS ===")
for _, unit in ipairs(df.global.world.units.active) do
    if unit.flags1.merchant or unit.flags1.diplomat then
        local name = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
        print(string.format("  %s merchant=%s diplomat=%s", name,
            tostring(unit.flags1.merchant), tostring(unit.flags1.diplomat)))
    end
end

print("\n=== STONE CRAFTS (for trade) ===")
local crafts = 0
for _, item in ipairs(df.global.world.items.all) do
    if not item.flags.in_building and not item.flags.forbid and not item.flags.in_job then
        if item:getType() == df.item_type.CRAFTS then
            crafts = crafts + 1
        end
    end
end
print(string.format("  Available crafts: %d", crafts))

print("\n=== FARM STATUS ===")
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.FarmPlot and bld.flags.exists then
        local season = df.global.cur_season
        local plant = bld.plant_id[season]
        local pname = "NONE"
        if plant >= 0 and plant < #df.global.world.raws.plants.all then
            pname = df.global.world.raws.plants.all[plant].id
        end
        print(string.format("  Farm id=%d at (%d,%d) size=%dx%d plant=%s",
            bld.id, bld.x1, bld.y1, bld.x2-bld.x1+1, bld.y2-bld.y1+1, pname))
    end
end

-- Brewable plants count
print("\n=== BREWABLE PLANTS ===")
local brewable = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.PLANT and not item.flags.in_building and not item.flags.forbid and not item.flags.in_job and not item.flags.rotten then
        brewable = brewable + 1
    end
end
print(string.format("  Brewable plants: %d", brewable))
