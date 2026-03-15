-- Add MANY brew jobs to the Still - this is urgent!
local still = nil
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.Workshop and 
       df.workshop_type[bld:getSubtype()] == "Still" and bld.flags.exists then
        still = bld
        break
    end
end

if not still then
    print("ERROR: Still not found!")
    return
end

-- Add 15 brew jobs
for i = 1, 15 do
    local job = df.job:new()
    job.job_type = df.job_type.CustomReaction
    job.reaction_name = "BREW_DRINK_FROM_PLANT"
    job.pos.x = still.centerx
    job.pos.y = still.centery
    job.pos.z = still.z
    local bref = df.general_ref_building_holderst:new()
    bref.building_id = still.id
    job.general_refs:insert('#', bref)
    dfhack.job.linkIntoWorld(job)
    still.jobs:insert('#', job)
end
print("Added 15 urgent brew jobs to Still! Total jobs: " .. #still.jobs)

-- Also add more jobs to Carpenter's for beds
local carpenters = nil
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.Workshop and 
       df.workshop_type[bld:getSubtype()] == "Carpenters" and bld.flags.exists then
        carpenters = bld
        break
    end
end

if carpenters then
    -- Add bed jobs
    for i = 1, 7 do
        local job = df.job:new()
        job.job_type = df.job_type.ConstructBed
        job.pos.x = carpenters.centerx
        job.pos.y = carpenters.centery  
        job.pos.z = carpenters.z
        local bref = df.general_ref_building_holderst:new()
        bref.building_id = carpenters.id
        job.general_refs:insert('#', bref)
        dfhack.job.linkIntoWorld(job)
        carpenters.jobs:insert('#', job)
    end
    -- Add barrel jobs (for brewing)
    for i = 1, 10 do
        local job = df.job:new()
        job.job_type = df.job_type.MakeBarrel
        job.pos.x = carpenters.centerx
        job.pos.y = carpenters.centery
        job.pos.z = carpenters.z
        local bref = df.general_ref_building_holderst:new()
        bref.building_id = carpenters.id
        job.general_refs:insert('#', bref)
        dfhack.job.linkIntoWorld(job)
        carpenters.jobs:insert('#', job)
    end
    print("Added 7 bed + 10 barrel jobs to Carpenter's")
end

-- Also add door jobs to Mason's
local masons = nil
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.Workshop and 
       df.workshop_type[bld:getSubtype()] == "Masons" and bld.flags.exists then
        masons = bld
        break
    end
end

if masons then
    for i = 1, 7 do
        local job = df.job:new()
        job.job_type = df.job_type.ConstructDoor
        job.pos.x = masons.centerx
        job.pos.y = masons.centery
        job.pos.z = masons.z
        local bref = df.general_ref_building_holderst:new()
        bref.building_id = masons.id
        job.general_refs:insert('#', bref)
        dfhack.job.linkIntoWorld(job)
        masons.jobs:insert('#', job)
    end
    -- Also some tables and chairs for dining area
    for i = 1, 4 do
        local job = df.job:new()
        job.job_type = df.job_type.ConstructTable
        job.pos.x = masons.centerx
        job.pos.y = masons.centery
        job.pos.z = masons.z
        local bref = df.general_ref_building_holderst:new()
        bref.building_id = masons.id
        job.general_refs:insert('#', bref)
        dfhack.job.linkIntoWorld(job)
        masons.jobs:insert('#', job)
    end
    for i = 1, 4 do
        local job = df.job:new()
        job.job_type = df.job_type.ConstructThrone
        job.pos.x = masons.centerx
        job.pos.y = masons.centery
        job.pos.z = masons.z
        local bref = df.general_ref_building_holderst:new()
        bref.building_id = masons.id
        job.general_refs:insert('#', bref)
        dfhack.job.linkIntoWorld(job)
        masons.jobs:insert('#', job)
    end
    print("Added 7 door + 4 table + 4 throne jobs to Mason's")
end
