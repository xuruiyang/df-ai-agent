-- Move all containers stuck in limbo to the map
local moved = 0
for _, item in ipairs(df.global.world.items.all) do
    if (item:getType() == df.item_type.BARREL or item:getType() == df.item_type.TOOL) then
        if item.pos.x < 0 then
            dfhack.items.moveToGround(item, xyz2pos(102, 103, 178))
            moved = moved + 1
            if moved > 50 then break end  -- only move 50 to avoid flooding
        end
    end
end
print("Moved " .. moved .. " containers to ground")

-- Also move any drink items in limbo
local drinks_moved = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.DRINK and item.pos.x < 0 then
        dfhack.items.moveToGround(item, xyz2pos(102, 104, 178))
        drinks_moved = drinks_moved + 1
    end
end
print("Moved " .. drinks_moved .. " drinks to ground")
