local WOOD = {{item_type=df.item_type.WOOD, quantity=1, vector_id=df.job_item_vector_id.WOOD}}

local function add_job(bld, job_type, mat_specs)
    local job = df.job:new()
    job.job_type = df.job_type[job_type]
    job.pos = xyz2pos(bld.centerx, bld.centery, bld.z)
    for _, spec in ipairs(mat_specs) do
        local ji = df.job_item:new()
        ji.item_type = spec.item_type
        ji.quantity = spec.quantity
        ji.vector_id = spec.vector_id
        ji.reaction_class = ""
        ji.has_material_reaction_product = ""
        job.job_items:insert('#', ji)
    end
    dfhack.job.linkIntoWorld(job)
    bld.jobs:insert('#', job)
    job.general_refs:insert('#', {new=df.general_ref_building_holderst, building_id=bld.id})
end

-- Find the new carpenter at (93,91,z94)
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) and bld.centerx == 93 and bld.centery == 91 and bld.z == 94 then
        for i = 1, 20 do
            add_job(bld, "MakeBarrel", WOOD)
        end
        print("Queued 20 barrels at new carpenter workshop")
        break
    end
end
