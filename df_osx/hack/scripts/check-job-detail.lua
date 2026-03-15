-- Check detailed job structure at carpenter's workshop
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.Workshop and 
       df.workshop_type[bld:getSubtype()] == "Carpenters" and bld.flags.exists then
        print(string.format("Carpenters id=%d: %d jobs", bld.id, #bld.jobs))
        for i, job in ipairs(bld.jobs) do
            if i <= 3 then
                local jt = df.job_type[job.job_type] or "?"
                print(string.format("  Job %d: %s", i, jt))
                print(string.format("    items: %d, job_items: %d", #job.items, #job.job_items))
                print(string.format("    flags: suspend=%s, repeat=%s", 
                    tostring(job.flags.suspend), tostring(job.flags['repeat'])))
                for j, ji in ipairs(job.job_items) do
                    print(string.format("    job_item[%d]: type=%s qty=%d", j, 
                        df.item_type[ji.item_type] or "?", ji.quantity))
                end
            end
        end
    end
end

-- Check a normally-created job for comparison
-- When a workshop creates a job through normal UI, it has job_items with material specs
-- Let's look at the Still's brew job
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.Workshop and 
       df.workshop_type[bld:getSubtype()] == "Still" and bld.flags.exists and #bld.jobs > 0 then
        print(string.format("\nStill id=%d: %d jobs", bld.id, #bld.jobs))
        local job = bld.jobs[0]
        local jt = df.job_type[job.job_type] or "?"
        print(string.format("  Job 0: %s reaction=%s", jt, job.reaction_name or ""))
        print(string.format("    items: %d, job_items: %d", #job.items, #job.job_items))
        break
    end
end
