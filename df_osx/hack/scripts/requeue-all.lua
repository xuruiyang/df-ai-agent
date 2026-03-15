local function find_workshop(ws_name)
    for _, bld in ipairs(df.global.world.buildings.all) do
        if bld:getType() == df.building_type.Workshop and 
           df.workshop_type[bld:getSubtype()] == ws_name and bld.flags.exists then
            return bld
        end
    end
    return nil
end

local function add_job(ws, job_type_name, reaction_name, count)
    for i = 1, count do
        local job = df.job:new()
        if reaction_name then
            job.job_type = df.job_type.CustomReaction
            job.reaction_name = reaction_name
        else
            job.job_type = df.job_type[job_type_name]
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
end

-- STILL: brew everything we can
local still = find_workshop("Still")
if still then
    add_job(still, nil, "BREW_DRINK_FROM_PLANT", 10)
    print("Queued 10 brew jobs")
end

-- CARPENTER: beds and barrels
local carp = find_workshop("Carpenters")
if carp then
    add_job(carp, "ConstructBed", nil, 8)
    add_job(carp, "MakeBarrel", nil, 5)
    add_job(carp, "ConstructBin", nil, 3)
    print("Queued 8 beds, 5 barrels, 3 bins")
end

-- MASON: doors, tables, thrones
local mason = find_workshop("Masons")
if mason then
    add_job(mason, "ConstructDoor", nil, 8)
    add_job(mason, "ConstructTable", nil, 4)
    add_job(mason, "ConstructThrone", nil, 4)
    print("Queued 8 doors, 4 tables, 4 thrones")
end

print("All production re-queued!")
