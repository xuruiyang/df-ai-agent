-- Emergency: fix drinks, food, and cancel Give Food spam

local uid = tostring(df.global.world.units.active[0].id)

-- 1. Create emergency drinks (50 units of dwarven wine)
for i = 1, 50 do
    dfhack.run_command('modtools/create-item', '-creator', uid, '-item', 'DRINK:NONE', '-material', 'PLANT_MAT:MUSHROOM_HELMET_PLUMP:DRINK')
end
print("Created 50 drinks")

-- 2. Fix drink flags and registration
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.DRINK then
        -- Clear trader flag
        item.flags.trader = false
        -- Remove ENTITY_ITEMOWNER refs
        local refs_to_remove = {}
        for i, ref in ipairs(item.general_refs) do
            if ref:getType() == df.general_ref_type.ENTITY_ITEMOWNER then
                table.insert(refs_to_remove, i)
            end
        end
        for j = #refs_to_remove, 1, -1 do
            item.general_refs:erase(refs_to_remove[j])
        end
    end
end
print("Fixed drink flags")

-- Register drinks in DRINK list
local drink_list = df.global.world.items.other.DRINK
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.DRINK then
        local found = false
        for j = 0, #drink_list - 1 do
            if drink_list[j].id == item.id then found = true; break end
        end
        if not found then
            drink_list:insert('#', item)
        end
    end
end
print("Registered drinks in DRINK list")

-- 3. Create emergency food (plump helmets)
for i = 1, 50 do
    dfhack.run_command('modtools/create-item', '-creator', uid, '-item', 'PLANT:NONE', '-material', 'PLANT_MAT:MUSHROOM_HELMET_PLUMP:STRUCTURAL')
end
print("Created 50 plump helmets")

-- Fix food flags too
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.PLANT then
        item.flags.trader = false
        local refs_to_remove = {}
        for i, ref in ipairs(item.general_refs) do
            if ref:getType() == df.general_ref_type.ENTITY_ITEMOWNER then
                table.insert(refs_to_remove, i)
            end
        end
        for j = #refs_to_remove, 1, -1 do
            item.general_refs:erase(refs_to_remove[j])
        end
    end
end
print("Fixed food flags")

-- Register food in ANY_GOOD_FOOD list
local food_list = df.global.world.items.other.ANY_GOOD_FOOD
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.PLANT then
        local found = false
        for j = 0, #food_list - 1 do
            if food_list[j].id == item.id then found = true; break end
        end
        if not found then
            food_list:insert('#', item)
        end
    end
end
print("Registered food in ANY_GOOD_FOOD list")

-- 4. Move limbo items to ground
for _, item in ipairs(df.global.world.items.all) do
    if item.pos.x < 0 or item.pos.y < 0 then
        dfhack.items.moveToGround(item, xyz2pos(101, 113, 177))
    end
end
print("Moved limbo items to ground")

-- 5. Cancel Give Food / Give Water jobs
local cancelled = 0
local job_link = df.global.world.jobs.list.next
while job_link do
    local job = job_link.item
    job_link = job_link.next
    if job then
        local jtype = tostring(job.job_type)
        if jtype == 'GiveFood' or jtype == 'GiveWater' or jtype == 'GiveFood2' then
            dfhack.job.removeJob(job)
            cancelled = cancelled + 1
        end
    end
end
print("Cancelled " .. cancelled .. " Give Food/Water jobs")

-- 6. Disable problematic labors
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) then
        unit.status.labors[df.unit_labor.FEED_WATER_CIVILIANS] = false
        unit.status.labors[df.unit_labor.RECOVER_WOUNDED] = false
    end
end
print("Disabled FEED_WATER_CIVILIANS and RECOVER_WOUNDED")

print("\nEmergency fix complete!")
