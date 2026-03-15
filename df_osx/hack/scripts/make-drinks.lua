-- Create dwarven wine directly
local uid = tostring(df.global.world.units.active[0].id)

-- Try different material formats for drinks
local attempts = {
    "PLANT_MAT:MUSHROOM_HELMET_PLUMP:DRINK",
    "MUSHROOM_HELMET_PLUMP:DRINK",
}

for _, mat in ipairs(attempts) do
    print("Trying material: " .. mat)
    local ok, err = pcall(function()
        dfhack.run_command('modtools/create-item', '-creator', uid, '-item', 'DRINK:NONE', '-material', mat)
    end)
    if ok then
        print("  Success!")
    else
        print("  Error: " .. tostring(err))
    end
end

-- Check what drink items exist
local drink_count = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.DRINK then
        drink_count = drink_count + 1
        if drink_count <= 5 then
            print(string.format("  Drink item: id=%d at %d,%d,%d", item.id, item.pos.x, item.pos.y, item.pos.z))
        end
    end
end
print("Total drink items: " .. drink_count)

-- If no drinks, try creating dwarven beer via the item directly
if drink_count == 0 then
    print("\nNo drinks found. Creating via Lua...")
    -- Find the plump helmet plant raw
    for i, raw in ipairs(df.global.world.raws.plants.all) do
        if raw.id == "MUSHROOM_HELMET_PLUMP" then
            print("Found plump helmet raw at index " .. i)
            local drink_mat = raw.material_defs.type_drink
            local drink_idx = raw.material_defs.idx_drink
            print("Drink material: type=" .. tostring(drink_mat) .. " idx=" .. tostring(drink_idx))
            break
        end
    end
end
