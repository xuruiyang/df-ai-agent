local function add_job_to_workshop(ws_name, job_type_name, count)
    local ws = nil
    for _, bld in ipairs(df.global.world.buildings.all) do
        if bld:getType() == df.building_type.Workshop and 
           df.workshop_type[bld:getSubtype()] == ws_name and 
           bld.flags.exists then
            ws = bld
            break
        end
    end
    if not ws then
        print("Workshop not found or not built: " .. ws_name)
        return
    end
    
    for i = 1, count do
        local job = df.job:new()
        job.job_type = df.job_type[job_type_name]
        if not job.job_type then
            print("Invalid job type: " .. job_type_name)
            return
        end
        job.pos.x = ws.centerx
        job.pos.y = ws.centery
        job.pos.z = ws.z
        
        local bref = df.general_ref_building_holderst:new()
        bref.building_id = ws.id
        job.general_refs:insert('#', bref)
        
        dfhack.job.linkIntoWorld(job)
        ws.jobs:insert('#', job)
    end
    print(string.format("Added %d %s jobs to %s", count, job_type_name, ws_name))
end

-- Carpenter jobs
add_job_to_workshop("Carpenters", "ConstructBed", 7)
add_job_to_workshop("Carpenters", "MakeBarrel", 5)
add_job_to_workshop("Carpenters", "ConstructBin", 3)

-- Mason jobs  
add_job_to_workshop("Masons", "ConstructDoor", 7)
add_job_to_workshop("Masons", "ConstructTable", 2)
add_job_to_workshop("Masons", "ConstructThrone", 2)  -- chairs

-- Also add more brewing
add_job_to_workshop("Still", "CustomReaction", 0) -- this won't work for custom reaction without name
