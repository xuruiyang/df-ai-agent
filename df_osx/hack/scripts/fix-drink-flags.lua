-- Fix drink items: clear trader flag and entity owner ref
local fixed = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.DRINK then
        -- Clear trader flag
        item.flags.trader = false
        -- Remove entity owner refs (makes it fortress property)
        local refs_to_remove = {}
        for i, ref in ipairs(item.general_refs) do
            if ref:getType() == df.general_ref_type.ENTITY_ITEMOWNER then
                table.insert(refs_to_remove, i)
            end
        end
        -- Remove in reverse order
        for j = #refs_to_remove, 1, -1 do
            item.general_refs:erase(refs_to_remove[j])
        end
        fixed = fixed + 1
    end
end
print("Fixed " .. fixed .. " drink items (cleared trader flag)")

-- Also fix any food items with trader flag
local food_fixed = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.PLANT then
        if item.flags.trader then
            item.flags.trader = false
            food_fixed = food_fixed + 1
        end
        -- Remove entity owner refs
        local refs_to_remove = {}
        for i, ref in ipairs(item.general_refs) do
            if ref:getType() == df.general_ref_type.ENTITY_ITEMOWNER then
                table.insert(refs_to_remove, i)
            end
        end
        for j = #refs_to_remove, 1, -1 do
            item.general_refs:erase(refs_to_remove[j])
        end
    end
end
print("Fixed " .. food_fixed .. " plant items with trader flag")

-- Fix barrels too
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BARREL then
        item.flags.trader = false
        local refs_to_remove = {}
        for i, ref in ipairs(item.general_refs) do
            if ref:getType() == df.general_ref_type.ENTITY_ITEMOWNER then
                table.insert(refs_to_remove, i)
            end
        end
        for j = #refs_to_remove, 1, -1 do
            item.general_refs:erase(refs_to_remove[j])
        end
    end
end
print("Fixed barrel flags too")
