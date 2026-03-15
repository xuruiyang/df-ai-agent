-- Helper: add a job with proper material specs to a workshop
local function add_job(ws, job_type_str, reaction_name, item_specs, count)
    for i = 1, count do
        local job = df.job:new()
        if reaction_name then
            job.job_type = df.job_type.CustomReaction
            job.reaction_name = reaction_name
        else
            job.job_type = df.job_type[job_type_str]
        end
        job.pos.x = ws.centerx; job.pos.y = ws.centery; job.pos.z = ws.z
        
        local bref = df.general_ref_building_holderst:new()
        bref.building_id = ws.id
        job.general_refs:insert('#', bref)
        
        -- Add material requirements
        for _, spec in ipairs(item_specs) do
            local ji = df.job_item:new()
            ji.item_type = spec.item_type
            ji.quantity = spec.quantity or 1
            if spec.vector_id then ji.vector_id = spec.vector_id end
            if spec.flags2 then
                for k,v in pairs(spec.flags2) do ji.flags2[k] = v end
            end
            job.job_items:insert('#', ji)
        end
        
        dfhack.job.linkIntoWorld(job)
        ws.jobs:insert('#', job)
    end
end

local function find_ws(name, z)
    for _, bld in ipairs(df.global.world.buildings.all) do
        if bld:getType() == df.building_type.Workshop and 
           df.workshop_type[bld:getSubtype()] == name and 
           bld.flags.exists and (not z or bld.z == z) then
            return bld
        end
    end
    return nil
end

-- Material specs
local WOOD = {{item_type=df.item_type.WOOD, quantity=1, vector_id=df.job_item_vector_id.WOOD}}
local STONE = {{item_type=df.item_type.BOULDER, quantity=1, vector_id=df.job_item_vector_id.BOULDER, flags2={building_material=true, non_economic=true}}}
local BREW = {
    {item_type=df.item_type.PLANT, quantity=1, vector_id=df.job_item_vector_id.ANY_COOKABLE},
    {item_type=df.item_type.BARREL, quantity=1, vector_id=df.job_item_vector_id.BARREL},
}

-- STILL: Brew drinks (HIGHEST PRIORITY)
local still = find_ws("Still", 96)
if still then
    add_job(still, nil, "BREW_DRINK_FROM_PLANT", BREW, 15)
    print("Still: 15 brew jobs queued")
end
local still2 = find_ws("Still", 97)
if still2 then
    add_job(still2, nil, "BREW_DRINK_FROM_PLANT", BREW, 15)
    print("Surface Still: 15 brew jobs queued")
end

-- CARPENTER: Beds, barrels, bins
local carp = find_ws("Carpenters", 96)
if carp then
    add_job(carp, "ConstructBed", nil, WOOD, 9)
    add_job(carp, "MakeBarrel", nil, WOOD, 10)
    add_job(carp, "ConstructBin", nil, WOOD, 5)
    print("Carpenters: 9 beds + 10 barrels + 5 bins queued")
end

-- MASON: Doors, tables, thrones
local mason = find_ws("Masons")
if mason then
    add_job(mason, "ConstructDoor", nil, STONE, 9)
    add_job(mason, "ConstructTable", nil, STONE, 4)
    add_job(mason, "ConstructThrone", nil, STONE, 4)
    print("Masons: 9 doors + 4 tables + 4 thrones queued")
end

print("\n=== PRODUCTION QUEUED ===")
