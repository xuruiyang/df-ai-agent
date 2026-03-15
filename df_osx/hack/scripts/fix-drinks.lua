-- Properly place drink items on the ground
local moved = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.DRINK then
        -- Use moveToGround to properly place on map
        dfhack.items.moveToGround(item, xyz2pos(101, 103, 178))
        moved = moved + 1
    end
end
print("Moved " .. moved .. " drink items to ground at 101,103,178")

-- Also move barrels
local barrels = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BARREL and item.pos.x < 0 then
        dfhack.items.moveToGround(item, xyz2pos(101, 104, 178))
        barrels = barrels + 1
    end
end
print("Moved " .. barrels .. " barrels to ground")
