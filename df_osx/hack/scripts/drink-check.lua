local drinks = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.DRINK and not item.flags.forbid then
        drinks = drinks + item.stack_size
    end
end
local plants = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.PLANT and not item.flags.in_building and not item.flags.forbid and not item.flags.rotten and not item.flags.in_job then
        plants = plants + 1
    end
end
local barrels = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BARREL and not item.flags.in_building and not item.flags.forbid and not item.flags.in_job then
        barrels = barrels + 1
    end
end
print(string.format("Drinks=%d Plants=%d Barrels=%d", drinks, plants, barrels))
