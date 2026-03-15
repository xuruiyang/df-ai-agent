-- Check trade depot and caravan status
print("=== Trade Depot Status ===")
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.TradeDepot then
        print(string.format("  Depot at (%d,%d,%d) id=%d", bld.x1, bld.y1, bld.z, bld.id))
        print(string.format("  Flags: exists=%s", tostring(bld.flags.exists)))
        -- Check if trade is possible
        if bld.trade_flags then
            print(string.format("  Trade flags: trader_requested=%s",
                tostring(bld.trade_flags.trader_requested)))
        end
    end
end

-- Check for caravan/merchant units
print("\n=== Caravan Units ===")
for _, unit in ipairs(df.global.world.units.active) do
    if not dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit) then
        local name = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
        if name == "" then name = "unnamed" end
        local prof = cycleOccupancy
    end
end

-- Simpler: just check for merchant flag
for _, unit in ipairs(df.global.world.units.active) do
    if unit.flags1.merchant or unit.flags1.diplomat then
        local name = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
        print(string.format("  %s (merchant=%s diplomat=%s)",
            name, tostring(unit.flags1.merchant), tostring(unit.flags1.diplomat)))
    end
end

-- Count our craft goods for trade
print("\n=== Trade Goods Available ===")
local crafts = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.SMALLGEM or
       (item:getType() == df.item_type.TOOL and not item.flags.in_building) then
        crafts = crafts + 1
    end
end
print(string.format("  Crafts/small gems: %d", crafts))

-- Count finished goods
local finished = 0
for _, item in ipairs(df.global.world.items.all) do
    if not item.flags.in_building and not item.flags.forbid and not item.flags.in_job then
        local tp = item:getType()
        if tp == df.item_type.CRAFTS then
            finished = finished + 1
        end
    end
end
print(string.format("  Stone crafts: %d", finished))
