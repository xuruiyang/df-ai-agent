-- Fix job IDs for workshop jobs
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.Workshop then
        for _, job in ipairs(bld.jobs) do
            if job.id == -1 then
                job.id = df.global.job_next_id
                df.global.job_next_id = df.global.job_next_id + 1

                -- Also need to add to the global job list (linked list)
                local link = df.job_list_link:new()
                link.item = job
                link.prev = df.global.world.jobs.list
                link.next = df.global.world.jobs.list.next
                if df.global.world.jobs.list.next then
                    df.global.world.jobs.list.next.prev = link
                end
                df.global.world.jobs.list.next = link

                print(string.format("Fixed job %s -> ID=%d", df.job_type[job.job_type], job.id))
            end
        end
    end
end

-- Verify
local count = 0
local link = df.global.world.jobs.list.next
while link do
    count = count + 1
    link = link.next
end
print("Total world jobs: " .. count)
