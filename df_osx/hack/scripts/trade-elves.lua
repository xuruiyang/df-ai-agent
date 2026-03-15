-- Set up trade with the elven caravan
-- 1. Request trader to depot
-- 2. Move trade goods to depot

local depot = df.building.find(7)
if not depot then
    print("ERROR: No trade depot!")
    return
end

-- Request trader
depot.trade_flags.trader_requested = true
print("Trader requested at depot")

-- Enable HAUL_TRADE on several dwarves
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) then
        unit.status.labors[df.unit_labor.HAUL_TRADE] = true
    end
end
print("Trade hauling enabled on all citizens")

-- Check what trade goods we can offer
-- We have lots of stone crafts potential, boulders, etc.
-- Let's create some stone crafts to trade
local boulder_count = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BOULDER and not item.flags.in_building and not item.flags.in_job then
        boulder_count = boulder_count + 1
    end
end
print("Available boulders for crafts: " .. boulder_count)

-- Check caravan status
print("\nCaravan/trade info:")
-- The depot should have caravan goods nearby
-- Let's check for merchant items
local merchant_items = 0
for _, item in ipairs(df.global.world.items.all) do
    if item.flags.trader then
        merchant_items = merchant_items + 1
    end
end
print("Merchant trade items: " .. merchant_items)

print("\nTo trade: use the depot to select goods.")
print("Elves won't buy wooden items (they get angry about tree-killing).")
print("Good trade goods: stone crafts, gems, metal items.")
