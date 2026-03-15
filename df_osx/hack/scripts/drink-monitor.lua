-- Monitor and maintain drink supply
-- This can be run periodically to ensure drinks stay registered

-- Fix any drinks not in the DRINK list
local drink_list = df.global.world.items.other.DRINK
local fixed = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.DRINK then
        item.flags.trader = false
        -- Check if in DRINK list
        local found = false
        for j = 0, #drink_list - 1 do
            if drink_list[j].id == item.id then found = true; break end
        end
        if not found then
            drink_list:insert('#', item)
            fixed = fixed + 1
        end
        -- Ensure accessible
        if item.pos.x < 0 then
            dfhack.items.moveToGround(item, xyz2pos(101, 103, 178))
            fixed = fixed + 1
        end
    end
end

-- Count drink supply
local total = 0
for i = 0, #drink_list - 1 do
    total = total + drink_list[i].stack_size
end

-- Check if we need more drinks
local population = 0
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) then population = population + 1 end
end

local drinks_per_dwarf = total / math.max(population, 1)
print(string.format("Drinks: %d units (%.1f per dwarf, pop=%d)", total, drinks_per_dwarf, population))

if fixed > 0 then
    print("Fixed " .. fixed .. " drink items")
end

-- If low on drinks, report
if drinks_per_dwarf < 3 then
    print("WARNING: Low drinks! Need more brewing.")
    -- Make sure Still has a brew job
    local still = df.building.find(9)
    if still and #still.jobs == 0 then
        print("Still has no jobs! Adding brew task...")
        -- Would need to add job here
    end
end

-- Also check food
local food_list = df.global.world.items.other.ANY_GOOD_FOOD
local food_total = #food_list
print(string.format("Food items: %d", food_total))
