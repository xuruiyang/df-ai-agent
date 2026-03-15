-- Check the DRINK list specifically
local drink_list = df.global.world.items.other.DRINK
print("items.other.DRINK count: " .. #drink_list)
for i = 0, math.min(#drink_list - 1, 5) do
    local item = drink_list[i]
    print(string.format("  id=%d stack=%d pos=%d,%d,%d rotten=%s forbid=%s",
        item.id, item.stack_size, item.pos.x, item.pos.y, item.pos.z,
        tostring(item.flags.rotten), tostring(item.flags.forbid)))
end

-- Check all items list for drinks
local all_drinks = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.DRINK then
        all_drinks = all_drinks + 1
    end
end
print("\nitems.all DRINK count: " .. all_drinks)

-- Check if items are in the .other list
if all_drinks > 0 and #drink_list == 0 then
    print("\nDrinks exist but NOT in items.other.DRINK!")
    print("This means modtools/create-item didn't add them to the specialized list.")
    print("The game tracks items in multiple lists; created items may be missing from .other")
end
