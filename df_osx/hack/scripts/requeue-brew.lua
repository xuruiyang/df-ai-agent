-- Requeue brew jobs on stills that have room
local function add_job(bld, job_type, mat_specs, reaction)
    local job = df.job:new()
    job.job_type = df.job_type[job_type]
    if reaction then job.reaction_name = reaction end
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

local BREW = {
    {item_type=df.item_type.PLANT, quantity=1, vector_id=df.job_item_vector_id.ANY_COOKABLE},
    {item_type=df.item_type.BARREL, quantity=1, vector_id=df.job_item_vector_id.BARREL},
}

local total = 0
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) and bld.type == df.workshop_type.Still then
        local to_add = 5 - #bld.jobs
        if to_add > 0 then
            for i = 1, to_add do
                add_job(bld, "CustomReaction", BREW, "BREW_DRINK_FROM_PLANT")
                total = total + 1
            end
        end
        print(string.format("  Still at (%d,%d,z%d): %d jobs now", bld.centerx, bld.centery, bld.z, #bld.jobs))
    end
end
print(string.format("Added %d brew jobs total", total))

-- Check drinks
local drinks = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.DRINK and not item.flags.forbid and not item.flags.dump then
        drinks = drinks + item.stack_size
    end
end
print(string.format("Current drinks: %d", drinks))
