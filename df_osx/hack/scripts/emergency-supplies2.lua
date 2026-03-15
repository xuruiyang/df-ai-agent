-- Create food and drink items right at the wagon where dwarves hang out
local uid = tostring(df.global.world.units.active[0].id)

-- Create plump helmets
for i = 1, 100 do
    dfhack.run_command('modtools/create-item', '-creator', uid, '-item', 'PLANT:NONE', '-material', 'PLANT_MAT:MUSHROOM_HELMET_PLUMP:STRUCTURAL')
end

-- Move all newly created items to the center of activity
local count = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.PLANT and item.pos.x < 0 then
        dfhack.items.moveToGround(item, xyz2pos(101, 102, 178))
        count = count + 1
    end
end
print("Created and placed " .. count .. " plump helmets at wagon")

-- Create dwarven wine (try creating as a liquid in a barrel)
-- First make empty barrels
for i = 1, 5 do
    dfhack.run_command('modtools/create-item', '-creator', uid, '-item', 'BARREL:NONE', '-material', 'PLANT_MAT:OAK:WOOD')
end
-- Move barrels
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BARREL and item.pos.x < 0 then
        dfhack.items.moveToGround(item, xyz2pos(101, 104, 178))
    end
end

-- Create drink items
for i = 1, 50 do
    dfhack.run_command('modtools/create-item', '-creator', uid, '-item', 'DRINK:NONE', '-material', 'PLANT_MAT:MUSHROOM_HELMET_PLUMP:DRINK')
end
-- Move drinks
local drinks = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.DRINK and item.pos.x < 0 then
        dfhack.items.moveToGround(item, xyz2pos(101, 105, 178))
        drinks = drinks + 1
    end
end
print("Created and placed " .. drinks .. " drink items")

-- Report
local food_total = 0
local drink_total = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.PLANT and item.pos.x >= 0 then food_total = food_total + 1 end
    if item:getType() == df.item_type.DRINK and item.pos.x >= 0 then drink_total = drink_total + 1 end
end
print(string.format("Total on-map: %d food, %d drinks", food_total, drink_total))
