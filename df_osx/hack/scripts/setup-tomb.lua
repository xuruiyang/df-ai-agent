local STONE = {{item_type=df.item_type.BOULDER, quantity=1, vector_id=df.job_item_vector_id.BOULDER, flags2={building_material=true, non_economic=true}}}

local function add_job(bld, job_type, mat_specs)
    local job = df.job:new()
    job.job_type = df.job_type[job_type]
    job.pos = xyz2pos(bld.centerx, bld.centery, bld.z)
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

-- Find mason
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) and bld.centerx == 95 and bld.centery == 105 then
        -- Queue coffins
        for i = 1, 5 do
            add_job(bld, "ConstructCoffin", STONE)
        end
        print("Queued 5 coffins at mason")
        break
    end
end
