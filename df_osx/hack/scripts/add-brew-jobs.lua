local still = nil
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.Workshop and 
       df.workshop_type[bld:getSubtype()] == "Still" and bld.flags.exists then
        still = bld
        break
    end
end

if still then
    for i = 1, 5 do
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
    print("Added 5 more brew jobs to Still, total jobs: " .. #still.jobs)
end
