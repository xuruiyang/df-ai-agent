-- Add stone craft job to craftsdwarf's workshop (ID=55)
local bld = df.building.find(55)
if not bld then print("Workshop 55 not found"); return end

if #bld.jobs == 0 then
    local job = df.job:new()
    job.job_type = df.job_type.MakeCrafts
    job.mat_type = 0  -- stone
    job.pos = xyz2pos(bld.x1 + 1, bld.y1 + 1, bld.z)
    job.flags['repeat'] = true

    local ref = df.general_ref_building_holderst:new()
    ref.building_id = bld.id
    job.general_refs:insert('#', ref)

    job.id = df.global.job_next_id
    df.global.job_next_id = df.global.job_next_id + 1
    local link = df.job_list_link:new()
    link.item = job
    link.prev = df.global.world.jobs.list
    link.next = df.global.world.jobs.list.next
    if df.global.world.jobs.list.next then
        df.global.world.jobs.list.next.prev = link
    end
    df.global.world.jobs.list.next = link
    bld.jobs:insert('#', job)
    print("Stone craft job added to workshop 55 (repeating)")
else
    print("Workshop already has " .. #bld.jobs .. " jobs")
end
