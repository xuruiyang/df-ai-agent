-- Queue extra beds, doors, and barrels for growth
local WOOD = {{item_type=df.item_type.WOOD, quantity=1, vector_id=df.job_item_vector_id.WOOD}}
local STONE = {{item_type=df.item_type.BOULDER, quantity=1, vector_id=df.job_item_vector_id.BOULDER, flags2={building_material=true, non_economic=true}}}

local function add_job(bld, job_type, mat_specs, reaction)
    local job = df.job:new()
    job.job_type = df.job_type[job_type]
    if reaction then job.reaction_name = reaction end
    job.pos = {x=bld.centerx, y=bld.centery, z=bld.z}
    for _, spec in ipairs(mat_specs) do
        local ji = df.job_item:new()
        ji.item_type = spec.item_type
        ji.quantity = spec.quantity
        ji.vector_id = spec.vector_id
        if spec.flags2 then
            for k, v in pairs(spec.flags2) do ji.flags2[k] = v end
        end
        ji.reaction_class = ""
        ji.has_material_reaction_product = ""
        job.job_items:insert('#', ji)
    end
    dfhack.job.linkIntoWorld(job)
    bld.jobs:insert('#', job)
    job.general_refs:insert('#', {new=df.general_ref_building_holderst, building_id=bld.id})
end

-- Find carpenter and mason
local carpenter, mason
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) then
        if bld.centerx == 91 and bld.centery == 108 then carpenter = bld end
        if bld.centerx == 95 and bld.centery == 105 then mason = bld end
    end
end

if carpenter then
    -- Queue 10 beds
    for i = 1, 10 do add_job(carpenter, "ConstructBed", WOOD) end
    -- Queue 10 barrels
    for i = 1, 10 do add_job(carpenter, "MakeBarrel", WOOD) end
    print("Queued 10 beds + 10 barrels at carpenter")
end

if mason then
    -- Queue 10 doors
    for i = 1, 10 do add_job(mason, "ConstructDoor", STONE) end
    print("Queued 10 doors at mason")
end
