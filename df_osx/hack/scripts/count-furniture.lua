-- Count beds, doors, barrels, bins, tables, chairs
local counts = {}
for _, item in ipairs(df.global.world.items.all) do
    local type_name = df.item_type[item:getType()] or "?"
    if type_name == "BED" or type_name == "DOOR" or type_name == "BARREL" or 
       type_name == "BIN" or type_name == "TABLE" or type_name == "CHAIR" then
        counts[type_name] = (counts[type_name] or 0) + 1
    end
end
print("Furniture inventory:")
for k, v in pairs(counts) do
    print(string.format("  %s: %d", k, v))
end
