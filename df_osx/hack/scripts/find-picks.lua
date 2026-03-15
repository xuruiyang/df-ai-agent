-- Find picks in the fortress
local count = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.WEAPON and item:getSubtype() >= 0 then
        local def = df.global.world.raws.itemdefs.weapons[item:getSubtype()]
        if def and string.find(def.id, "PICK") then
            count = count + 1
            local inv = "on ground"
            if item.flags.in_inventory then inv = "in inventory" end
            print(string.format("Pick #%d: id=%d, %s, pos=%d,%d,%d", count, item.id, inv, item.pos.x, item.pos.y, item.pos.z))
        end
    end
end
if count == 0 then
    print("NO PICKS FOUND! Your miner cannot dig without a pick.")
    print("You need to either: embark with picks, or forge one at a Metalsmith's Forge.")
else
    print(string.format("Total picks: %d", count))
end
