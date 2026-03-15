-- Force brewing by ensuring the Still job is correct and materials are available
-- The ProcessPlantsBarrel job needs:
-- 1. A brewable plant (plump helmet)
-- 2. An empty barrel or rock pot

-- Check Still
local still = df.building.find(9)
if not still then
    print("ERROR: Still not found!")
    return
end

print("Still at " .. still.x1 .. "," .. still.y1 .. "," .. still.z)
print("Still jobs: " .. #still.jobs)

-- Check what items are near the still
local sx, sy, sz = still.x1+1, still.y1+1, still.z
print(string.format("Still center: %d,%d,%d", sx, sy, sz))

-- Find plants within 20 tiles
local plants_near = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.PLANT and not item.flags.in_job and not item.flags.forbid then
        local dist = math.abs(item.pos.x - sx) + math.abs(item.pos.y - sy) + math.abs(item.pos.z - sz) * 10
        if dist < 30 then
            plants_near = plants_near + 1
            if plants_near <= 3 then
                print(string.format("  Plant near still: %d,%d,%d dist=%d", item.pos.x, item.pos.y, item.pos.z, dist))
            end
        end
    end
end
print("Plants near still: " .. plants_near)

-- Find empty containers near still
local empty_containers = 0
for _, item in ipairs(df.global.world.items.all) do
    if (item:getType() == df.item_type.BARREL or item:getType() == df.item_type.TOOL)
       and not item.flags.in_job and not item.flags.forbid and not item.flags.in_building then
        -- Check if empty (no contained items)
        local is_empty = true
        for _, ref in ipairs(item.general_refs) do
            if ref:getType() == df.general_ref_type.CONTAINS_ITEM then
                is_empty = false
                break
            end
        end
        if is_empty then
            empty_containers = empty_containers + 1
            if empty_containers <= 3 then
                print(string.format("  Empty container at %d,%d,%d", item.pos.x, item.pos.y, item.pos.z))
            end
        end
    end
end
print("Empty containers: " .. empty_containers)

-- Check if dwarves with BREWER labor exist
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) and unit.status.labors[df.unit_labor.BREWER] then
        local name = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
        print("Brewer: " .. name .. " (job: " .. df.job_type[unit.job.current_job and unit.job.current_job.job_type or -1] .. ")")
    end
end
