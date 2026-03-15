-- Create drinks and fix ALL registration issues
local uid = tostring(df.global.world.units.active[0].id)

-- Create 30 more drinks
for i = 1, 30 do
    dfhack.run_command('modtools/create-item', '-creator', uid, '-item', 'DRINK:NONE', '-material', 'PLANT_MAT:MUSHROOM_HELMET_PLUMP:DRINK')
end

-- Fix ALL drink items
local drink_list = df.global.world.items.other.DRINK
local total_fixed = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.DRINK then
        item.flags.trader = false
        -- Remove entity owner refs
        local refs_to_remove = {}
        for i, ref in ipairs(item.general_refs) do
            if ref:getType() == df.general_ref_type.ENTITY_ITEMOWNER then
                table.insert(refs_to_remove, i)
            end
        end
        for j = #refs_to_remove, 1, -1 do
            item.general_refs:erase(refs_to_remove[j])
        end
        -- Add to DRINK list if not there
        local found = false
        for j = 0, #drink_list - 1 do
            if drink_list[j].id == item.id then found = true; break end
        end
        if not found then
            drink_list:insert('#', item)
            total_fixed = total_fixed + 1
        end
        -- Move to ground if in limbo
        if item.pos.x < 0 then
            dfhack.items.moveToGround(item, xyz2pos(101, 103, 178))
        end
    end
end
print("Fixed " .. total_fixed .. " drinks")

-- Count
local total_units = 0
for i = 0, #drink_list - 1 do
    total_units = total_units + drink_list[i].stack_size
end
print("Total drink units: " .. total_units)
