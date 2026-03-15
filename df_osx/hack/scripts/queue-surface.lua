-- Find all Stills and queue brew jobs
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.Workshop and 
       df.workshop_type[bld:getSubtype()] == "Still" and bld.flags.exists then
        if #bld.jobs < 3 then
            -- Add brew jobs
            for i = 1, 10 do
                local job = df.job:new()
                job.job_type = df.job_type.CustomReaction
                job.reaction_name = "BREW_DRINK_FROM_PLANT"
                job.pos.x = bld.centerx
                job.pos.y = bld.centery
                job.pos.z = bld.z
                local bref = df.general_ref_building_holderst:new()
                bref.building_id = bld.id
                job.general_refs:insert('#', bref)
                dfhack.job.linkIntoWorld(job)
                bld.jobs:insert('#', job)
            end
            print(string.format("Added 10 brew jobs to Still id=%d at z%d", bld.id, bld.z))
        else
            print(string.format("Still id=%d already has %d jobs", bld.id, #bld.jobs))
        end
    end
end

-- Also queue beds on any carpenter's workshop that's ready
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.Workshop and
       df.workshop_type[bld:getSubtype()] == "Carpenters" and bld.flags.exists then
        if #bld.jobs < 3 then
            for i = 1, 8 do
                local job = df.job:new()
                job.job_type = df.job_type.ConstructBed
                job.pos.x = bld.centerx
                job.pos.y = bld.centery
                job.pos.z = bld.z
                local bref = df.general_ref_building_holderst:new()
                bref.building_id = bld.id
                job.general_refs:insert('#', bref)
                dfhack.job.linkIntoWorld(job)
                bld.jobs:insert('#', job)
            end
            print(string.format("Added 8 bed jobs to Carpenters id=%d at z%d", bld.id, bld.z))
        end
    end
end
