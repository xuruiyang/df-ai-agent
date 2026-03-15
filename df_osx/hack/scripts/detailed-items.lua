-- Detailed item check - count all furniture INCLUDING installed
local counts = {free={}, installed={}, total={}}
local check_types = {"BED", "DOOR", "TABLE", "CHAIR", "BARREL", "BIN", "DRINK", "PLANT", "SEEDS"}

for _, item in ipairs(df.global.world.items.all) do
    local type_name = df.item_type[item:getType()] or "?"
    for _, ct in ipairs(check_types) do
        if type_name == ct then
            counts.total[ct] = (counts.total[ct] or 0) + 1
            if item.flags.in_building then
                counts.installed[ct] = (counts.installed[ct] or 0) + 1
            elseif item.pos.x > 0 then
                counts.free[ct] = (counts.free[ct] or 0) + 1
            end
        end
    end
end

print("Item Type      | Free | Installed | Total")
print("---------------|------|-----------|------")
for _, ct in ipairs(check_types) do
    print(string.format("%-15s| %4d | %9d | %5d", ct, 
        counts.free[ct] or 0, counts.installed[ct] or 0, counts.total[ct] or 0))
end

-- Check drink details
print("\nDrink details:")
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.DRINK and item.pos.x > 0 then
        local name = dfhack.items.getDescription(item, 0)
        print(string.format("  %s (stack=%d) at (%d,%d,%d)", name, item.stack_size, item.pos.x, item.pos.y, item.pos.z))
    end
end
