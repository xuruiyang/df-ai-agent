-- First, clear all existing malformed jobs from workshops
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.Workshop and bld.flags.exists then
        while #bld.jobs > 0 do
            local job = bld.jobs[0]
            dfhack.job.removeJob(job)
        end
    end
end
print("Cleared all workshop jobs")

-- Helper to add a job WITH proper job_items
local function add_proper_job(ws, job_type_str, reaction_name, job_items_specs, count)
    for i = 1, count do
        local job = df.job:new()
        if reaction_name then
            job.job_type = df.job_type.CustomReaction
            job.reaction_name = reaction_name
        else
            job.job_type = df.job_type[job_type_str]
        end
        job.pos.x = ws.centerx
        job.pos.y = ws.centery
        job.pos.z = ws.z
        
        -- Add building reference
        local bref = df.general_ref_building_holderst:new()
        bref.building_id = ws.id
        job.general_refs:insert('#', bref)
        
        -- Add job_items (material requirements)
        for _, spec in ipairs(job_items_specs) do
            local ji = df.job_item:new()
            ji.item_type = spec.item_type
            ji.quantity = spec.quantity or 1
            if spec.vector_id then
                ji.vector_id = spec.vector_id
            end
            if spec.mat_type then
                ji.mat_type = spec.mat_type
            end
            if spec.flags2 then
                for k, v in pairs(spec.flags2) do
                    ji.flags2[k] = v
                end
            end
            if spec.flags3 then
                for k, v in pairs(spec.flags3) do
                    ji.flags3[k] = v
                end
            end
            job.job_items:insert('#', ji)
        end
        
        dfhack.job.linkIntoWorld(job)
        ws.jobs:insert('#', job)
    end
end

local function find_ws(name)
    local results = {}
    for _, bld in ipairs(df.global.world.buildings.all) do
        if bld:getType() == df.building_type.Workshop and 
           df.workshop_type[bld:getSubtype()] == name and bld.flags.exists then
            table.insert(results, bld)
        end
    end
    return results
end

-- STILL: Brew drink from plant
-- Requires: 1 plant (brewable), 1 barrel/pot
local stills = find_ws("Still")
for _, still in ipairs(stills) do
    add_proper_job(still, nil, "BREW_DRINK_FROM_PLANT", {
        {item_type = df.item_type.PLANT, quantity = 1, vector_id = df.job_item_vector_id.ANY_COOKABLE},
        {item_type = df.item_type.BARREL, quantity = 1, vector_id = df.job_item_vector_id.BARREL},
    }, 10)
    print(string.format("Added 10 brew jobs to Still id=%d (with materials)", still.id))
end

-- CARPENTER: Construct Bed (needs 1 wood log)
local carps = find_ws("Carpenters")
for _, carp in ipairs(carps) do
    add_proper_job(carp, "ConstructBed", nil, {
        {item_type = df.item_type.WOOD, quantity = 1, vector_id = df.job_item_vector_id.WOOD},
    }, 8)
    add_proper_job(carp, "MakeBarrel", nil, {
        {item_type = df.item_type.WOOD, quantity = 1, vector_id = df.job_item_vector_id.WOOD},
    }, 5)
    print(string.format("Added 8 bed + 5 barrel jobs to Carpenters id=%d", carp.id))
end

-- MASON: Construct Door (needs 1 boulder)
local masons = find_ws("Masons")
for _, mason in ipairs(masons) do
    add_proper_job(mason, "ConstructDoor", nil, {
        {item_type = df.item_type.BOULDER, quantity = 1, vector_id = df.job_item_vector_id.BOULDER,
         flags2 = {building_material = true, non_economic = true}},
    }, 8)
    add_proper_job(mason, "ConstructTable", nil, {
        {item_type = df.item_type.BOULDER, quantity = 1, vector_id = df.job_item_vector_id.BOULDER,
         flags2 = {building_material = true, non_economic = true}},
    }, 4)
    add_proper_job(mason, "ConstructThrone", nil, {
        {item_type = df.item_type.BOULDER, quantity = 1, vector_id = df.job_item_vector_id.BOULDER,
         flags2 = {building_material = true, non_economic = true}},
    }, 4)
    print(string.format("Added 8 door + 4 table + 4 throne jobs to Masons id=%d", mason.id))
end

print("\nAll jobs re-queued with proper material specifications!")
