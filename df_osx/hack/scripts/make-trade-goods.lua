-- Build a Craftsdwarf's Workshop and make stone crafts for trade
local function get_free_boulder()
    for _, item in ipairs(df.global.world.items.all) do
        if item:getType() == df.item_type.BOULDER and not item.flags.in_building and not item.flags.in_job and not item.flags.forbid then
            return item
        end
    end
    return nil
end

-- Build Craftsdwarf's Workshop on z=177
local boulder = get_free_boulder()
if boulder then
    local crafts = dfhack.buildings.constructBuilding{
        type = df.building_type.Workshop,
        subtype = df.workshop_type.Craftsdwarfs,
        pos = xyz2pos(93, 113, 177),
        width = 3,
        height = 3,
        items = {boulder},
    }
    if crafts then
        print("Craftsdwarf's workshop built, ID=" .. crafts.id)
        dfhack.run_command('build-now')

        -- Add stone crafting job
        local job = df.job:new()
        job.job_type = df.job_type.MakeCrafts  -- Stone crafts
        job.mat_type = 0  -- stone
        job.pos = xyz2pos(crafts.x1 + 1, crafts.y1 + 1, crafts.z)
        job.flags['repeat'] = true

        local ref = df.general_ref_building_holderst:new()
        ref.building_id = crafts.id
        job.general_refs:insert('#', ref)
        dfhack.job.linkIntoWorld(job)
        crafts.jobs:insert('#', job)

        -- Fix job ID if needed
        if job.id == -1 then
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
        end
        print("Stone crafting job added (repeating)")
    else
        print("Failed to place Craftsdwarf's workshop")
    end
else
    print("No boulders available!")
end

-- Enable STONE_CRAFT labor on several dwarves
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) then
        unit.status.labors[df.unit_labor.STONE_CRAFT] = true
    end
end
print("Stone crafting enabled on all citizens")
