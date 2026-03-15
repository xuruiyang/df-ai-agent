-- Manage production priorities for 41 dwarves

-- Check all carpenter workshops
print("=== CARPENTER WORKSHOPS ===")
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) and bld.type == df.workshop_type.Carpenters then
        -- Count job types
        local barrel_jobs = 0
        local bed_jobs = 0
        local other_jobs = 0
        for _, job in ipairs(bld.jobs) do
            if job.job_type == df.job_type.MakeBarrel then
                barrel_jobs = barrel_jobs + 1
            elseif job.job_type == df.job_type.ConstructBed then
                bed_jobs = bed_jobs + 1
            else
                other_jobs = other_jobs + 1
            end
        end
        print(string.format("  (%d,%d,z%d) exists=%s total=%d barrels=%d beds=%d other=%d",
            bld.centerx, bld.centery, bld.z, tostring(bld.flags.exists),
            #bld.jobs, barrel_jobs, bed_jobs, other_jobs))
    end
end

-- Check coffin count
local coffins_free = 0
local coffins_placed = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.COFFIN then
        if item.flags.in_building then coffins_placed = coffins_placed + 1
        elseif not item.flags.forbid and not item.flags.in_job then coffins_free = coffins_free + 1
        end
    end
end
print(string.format("\nCoffins: %d placed, %d free", coffins_placed, coffins_free))

-- Check beds
local beds_free = 0
local beds_placed = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BED then
        if item.flags.in_building then beds_placed = beds_placed + 1
        elseif not item.flags.forbid and not item.flags.in_job then beds_free = beds_free + 1
        end
    end
end
print(string.format("Beds: %d placed, %d free", beds_placed, beds_free))

-- Mason jobs
print("\n=== MASON ===")
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) and bld.type == df.workshop_type.Masons then
        print(string.format("  (%d,%d,z%d) jobs=%d exists=%s", bld.centerx, bld.centery, bld.z, #bld.jobs, tostring(bld.flags.exists)))
    end
end

-- Check for unburied corpses
print("\n=== CORPSES ===")
local corpses = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.CORPSE and not item.flags.in_building then
        corpses = corpses + 1
    end
end
print(string.format("  Unburied corpses: %d", corpses))
