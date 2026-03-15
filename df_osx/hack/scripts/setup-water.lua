-- Setup water access through a water source activity zone
-- And fix the drink production pipeline

-- Step 1: Create an activity zone at the water location on z=177
-- Zone over the water tiles at (59-62, 104-110, z=177)
local zone = df.building_civzonest:new()
zone.x1 = 58
zone.y1 = 103
zone.x2 = 63
zone.y2 = 111
zone.z = 177
zone.race = -1
zone.flags.exists = true

-- Set zone properties
zone.zone_flags.active = true
zone.zone_flags.water_source = true  -- Mark as water source

-- Assign building ID
zone.id = df.global.building_next_id
df.global.building_next_id = df.global.building_next_id + 1

-- Register in building list
df.global.world.buildings.all:insert('#', zone)

print("Water source zone created! ID=" .. zone.id)
print("Location: 58-63, 103-111, z=177")

-- Step 2: Also create a proper meeting zone (dining area) on surface
-- near the wagon so dwarves gather there
local meeting = df.building_civzonest:new()
meeting.x1 = 98
meeting.y1 = 99
meeting.x2 = 104
meeting.y2 = 105
meeting.z = 178
meeting.race = -1
meeting.flags.exists = true
meeting.zone_flags.active = true
meeting.zone_flags.meeting = true  -- meeting/dining area
meeting.id = df.global.building_next_id
df.global.building_next_id = df.global.building_next_id + 1
df.global.world.buildings.all:insert('#', meeting)
print("Meeting zone created! ID=" .. meeting.id)

-- Step 3: Fix the drink production
-- The key issue: modtools/create-item doesn't add drinks to items.other.DRINK
-- Solution: After brewing produces drinks naturally, they'll be in the right list
-- For now, create more drinks AND add them to the list properly

local uid = tostring(df.global.world.units.active[0].id)

-- Create 30 more drink items
for i = 1, 30 do
    dfhack.run_command('modtools/create-item', '-creator', uid, '-item', 'DRINK:NONE', '-material', 'PLANT_MAT:MUSHROOM_HELMET_PLUMP:DRINK')
end

-- Fix ALL drink items: clear trader flag, add to DRINK list
local drink_list = df.global.world.items.other.DRINK
local total_fixed = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.DRINK then
        -- Clear trader flag
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
        -- Add to DRINK list if not already there
        local found = false
        for j = 0, #drink_list - 1 do
            if drink_list[j].id == item.id then
                found = true
                break
            end
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
print("Fixed and registered " .. total_fixed .. " new drink items")

-- Count total
local total_units = 0
for i = 0, #drink_list - 1 do
    total_units = total_units + drink_list[i].stack_size
end
print("Total drink units available: " .. total_units)
