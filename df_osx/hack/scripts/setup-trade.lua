-- Request trader at depot
local depot
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.TradeDepot then
        depot = bld
        break
    end
end

if not depot then
    print("No trade depot found!")
    return
end

-- Request trader
depot.trade_flags.trader_requested = true
print("Trader requested at depot")
print("Broker should visit depot when trader arrives")

-- Count available trade goods
local crafts = 0
local extra_bins = 0
local extra_barrels = 0

for _, item in ipairs(df.global.world.items.all) do
    if not item.flags.in_building and not item.flags.forbid and not item.flags.in_job then
        local tp = item:getType()
        if tp == df.item_type.CRAFTS then crafts = crafts + 1 end
        if tp == df.item_type.BIN then extra_bins = extra_bins + 1 end
    end
end

print(string.format("\nTrade goods available:"))
print(string.format("  Crafts: %d", crafts))
print(string.format("  Bins: %d (containers for hauling)", extra_bins))
