-- Emergency: move all food and drink items to ground near wagon
-- and create more accessible food

local uid = tostring(df.global.world.units.active[0].id)

-- Move all plant items to the surface
local moved = 0
for _, item in ipairs(df.global.world.items.all) do
    if (item:getType() == df.item_type.PLANT or item:getType() == df.item_type.MEAT
        or item:getType() == df.item_type.FISH or item:getType() == df.item_type.CHEESE
        or item:getType() == df.item_type.FOOD) then
        if item.pos.x < 0 or item.pos.x > 300 then
            dfhack.items.moveToGround(item, xyz2pos(101, 103, 178))
            moved = moved + 1
        end
    end
end
print("Moved " .. moved .. " food items to accessible location")

-- Create more plump helmets at the wagon area
for i = 1, 50 do
    dfhack.run_command('modtools/create-item', '-creator', uid, '-item', 'PLANT:NONE', '-material', 'PLANT_MAT:MUSHROOM_HELMET_PLUMP:STRUCTURAL')
end
print("Created 50 more plump helmets")

-- Move newly created items to ground
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.PLANT and (item.pos.x < 0 or item.pos.x > 300) then
        dfhack.items.moveToGround(item, xyz2pos(101, 103, 178))
    end
end

-- Also create some rock pots (for brewing since we might not have barrels)
for i = 1, 10 do
    dfhack.run_command('modtools/create-item', '-creator', uid, '-item', 'BARREL:NONE', '-material', 'PLANT_MAT:OAK:WOOD')
end

-- Move barrels
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BARREL and (item.pos.x < 0 or item.pos.x > 300) then
        dfhack.items.moveToGround(item, xyz2pos(101, 104, 178))
    end
end

print("Emergency food supplies in place!")

-- Count
local food = 0
local drink = 0
local barrel = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.PLANT then food = food + 1 end
    if item:getType() == df.item_type.DRINK then drink = drink + 1 end
    if item:getType() == df.item_type.BARREL then barrel = barrel + 1 end
end
print(string.format("Plants: %d, Drinks: %d, Barrels: %d", food, drink, barrel))
