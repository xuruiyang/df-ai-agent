-- Force-create workshop jobs by properly linking them
local function make_workshop_job(building_id, job_type_val, name)
    local bld = df.building.find(building_id)
    if not bld then
        print("Building " .. building_id .. " not found")
        return
    end

    -- Skip if workshop already has this job type
    for _, existing in ipairs(bld.jobs) do
        if existing.job_type == job_type_val then
            print(name .. " already queued")
            return
        end
    end

    local job = df.job:new()
    job.job_type = job_type_val
    job.pos = xyz2pos(bld.x1 + 1, bld.y1 + 1, bld.z)
    job.flags['repeat'] = true  -- repeat the job

    -- Add building holder ref
    local ref = df.general_ref_building_holderst:new()
    ref.building_id = building_id
    job.general_refs:insert('#', ref)

    -- Link into world job list
    dfhack.job.linkIntoWorld(job)

    -- Add to building's job list
    bld.jobs:insert('#', job)

    print(name .. " job created (ID=" .. job.id .. ")")
end

-- Carpenter workshop (ID=8): beds, barrels, bins, doors
make_workshop_job(8, df.job_type.ConstructBed, "Bed")
make_workshop_job(8, df.job_type.MakeBarrel, "Barrel")

-- Still (ID=9): brew
make_workshop_job(9, df.job_type.ProcessPlantsBarrel, "Brew")

-- Mason (ID=10): thrones, tables, doors
make_workshop_job(10, df.job_type.ConstructThrone, "Throne")
make_workshop_job(10, df.job_type.ConstructTable, "Table")
make_workshop_job(10, df.job_type.ConstructDoor, "Door")

print("\nAll workshop jobs created!")

-- Verify
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.Workshop then
        print(string.format("Workshop %d: %d jobs", bld.id, #bld.jobs))
        for _, job in ipairs(bld.jobs) do
            print(string.format("  -> %s (id=%d)", df.job_type[job.job_type], job.id))
        end
    end
end
