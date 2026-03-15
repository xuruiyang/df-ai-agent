-- Queue crafts at the z96 workshop (the one that exists)
-- The stone might not be on z96 so dwarves will haul it up
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

local STONE = {{item_type=df.item_type.BOULDER, quantity=1, vector_id=df.job_item_vector_id.BOULDER, flags2={building_material=true, non_economic=true}}}

for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) and bld.type == df.workshop_type.Craftsdwarfs then
        if bld.flags.exists and #bld.jobs == 0 then
            for i = 1, 10 do
                add_job(bld, "MakeCrafts", STONE)
            end
            print(string.format("Queued 10 crafts at Craftsdwarfs (%d,%d,z%d)", bld.centerx, bld.centery, bld.z))
        end
    end
end

-- Also requeue brew jobs
local BREW = {
    {item_type=df.item_type.PLANT, quantity=1, vector_id=df.job_item_vector_id.ANY_COOKABLE},
    {item_type=df.item_type.BARREL, quantity=1, vector_id=df.job_item_vector_id.BARREL},
}
local total_brew = 0
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) and bld.type == df.workshop_type.Still and bld.flags.exists then
        local to_add = 5 - #bld.jobs
        if to_add > 0 then
            for i = 1, to_add do
                add_job(bld, "CustomReaction", BREW, "BREW_DRINK_FROM_PLANT")
                total_brew = total_brew + 1
            end
        end
    end
end
if total_brew > 0 then print(string.format("Requeued %d brew jobs", total_brew)) end
