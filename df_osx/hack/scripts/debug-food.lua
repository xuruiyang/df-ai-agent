-- Debug food accessibility
local food_accessible = 0
local food_limbo = 0
local food_container = 0

for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.PLANT or item:getType() == df.item_type.MEAT
       or item:getType() == df.item_type.FISH or item:getType() == df.item_type.FOOD then
        if item.pos.x < 0 then
            food_limbo = food_limbo + 1
        else
            -- Check if in container
            local in_container = false
            for _, ref in ipairs(item.general_refs) do
                if ref:getType() == df.general_ref_type.CONTAINED_IN_ITEM then
                    in_container = true
                    break
                end
            end
            if in_container then
                food_container = food_container + 1
            else
                food_accessible = food_accessible + 1
            end
        end
    end
end

print(string.format("Food - accessible: %d, in containers: %d, in limbo: %d",
    food_accessible, food_container, food_limbo))

-- Check specifically edible items on the surface (z=178)
local surface_food = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.PLANT and item.pos.z == 178 and not item.flags.forbid then
        surface_food = surface_food + 1
        if surface_food <= 3 then
            local desc = dfhack.items.getDescription(item, 0)
            print(string.format("  Food on surface: %s at %d,%d,%d forbid=%s in_job=%s",
                desc, item.pos.x, item.pos.y, item.pos.z,
                tostring(item.flags.forbid), tostring(item.flags.in_job)))
        end
    end
end
print("Surface food items: " .. surface_food)

-- Check item flags that might prevent eating
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.PLANT and item.pos.z == 178 and surface_food <= 5 then
        print(string.format("  flags: dump=%s hidden=%s trader=%s owned=%s",
            tostring(item.flags.dump), tostring(item.flags.hidden),
            tostring(item.flags.trader), tostring(item.flags.owned)))
        break
    end
end
