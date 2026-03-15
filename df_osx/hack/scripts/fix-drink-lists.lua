-- Add drink items to the items.other.DRINK list
local drink_list = df.global.world.items.other.DRINK
local added = 0

for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.DRINK then
        -- Check if already in the list
        local found = false
        for j = 0, #drink_list - 1 do
            if drink_list[j].id == item.id then
                found = true
                break
            end
        end
        if not found then
            drink_list:insert('#', item)
            added = added + 1
            print(string.format("Added drink id=%d stack=%d to DRINK list", item.id, item.stack_size))
        end
    end
end
print("Added " .. added .. " drinks to items.other.DRINK")
print("DRINK list now has " .. #drink_list .. " items")

-- Also add to ANY_GOOD_FOOD if applicable
-- Actually drinks aren't food, they're separate. Let's just verify.
local total_drink_units = 0
for i = 0, #drink_list - 1 do
    total_drink_units = total_drink_units + drink_list[i].stack_size
end
print("Total drink units: " .. total_drink_units)
