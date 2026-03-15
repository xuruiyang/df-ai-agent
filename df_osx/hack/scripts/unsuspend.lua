-- unsuspend construction jobs; buildingplan-safe
--[====[

unsuspend
=========
Unsuspends building construction jobs, except for jobs managed by `buildingplan`
and those where water flow > 1. See `autounsuspend` for keeping new jobs
unsuspended.
]====]

local buildingplan = require('plugins.buildingplan')

local joblist = df.global.world.jobs.list.next
local unsuspended_count, flow_count, buildingplan_count = 0, 0, 0

while joblist do
    local job = joblist.item
    joblist = joblist.next

    if job.job_type == df.job_type.ConstructBuilding and job.flags.suspend then
        if dfhack.maps.getTileFlags(job.pos).flow_size > 1 then
            flow_count = flow_count + 1
            goto continue
        end
        local bld = dfhack.buildings.findAtTile(job.pos)
        if bld and buildingplan.isPlannedBuilding(bld) then
            buildingplan_count = buildingplan_count + 1
            goto continue
        end
        job.flags.suspend = false
        unsuspended_count = unsuspended_count + 1
        ::continue::
    end
end

if flow_count > 0 then
    print(string.format('Skipped %d underwater job(s)', flow_count))
end
if buildingplan_count > 0 then
    print(string.format('Skipped %d buildingplan job(s)', buildingplan_count))
end
print(string.format('Unsuspended %d job(s).', unsuspended_count))
