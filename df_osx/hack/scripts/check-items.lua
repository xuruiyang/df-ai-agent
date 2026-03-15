-- Check for picks, axes, and other key items
local items_found = {}
for _, item in ipairs(df.global.world.items.all) do
    local name = dfhack.items.getDescription(item, 0)
    local type_name = df.item_type[item:getType()] or "?"
    if type_name == "WEAPON" or type_name == "TOOL" then
        if name:lower():find("pick") or name:lower():find("axe") then
            local pos = item.pos
            print(string.format("  %s [id=%d] at (%d,%d,%d) - %s", name, item.id, pos.x, pos.y, pos.z, type_name))
        end
    end
end

-- Also count all item types
local counts = {}
for _, item in ipairs(df.global.world.items.all) do
    local type_name = df.item_type[item:getType()] or "?"
    counts[type_name] = (counts[type_name] or 0) + 1
end
print("\nItem type counts:")
for k, v in pairs(counts) do
    print(string.format("  %s: %d", k, v))
end
