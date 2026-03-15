-- Queue 20 beds at a carpenter workshop (regardless of existing queue)
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

local WOOD = {{item_type=df.item_type.WOOD, quantity=1, vector_id=df.job_item_vector_id.WOOD}}

-- Find first carpenter and add beds
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) and bld.type == df.workshop_type.Carpenters then
        for i = 1, 20 do
            add_job(bld, "ConstructBed", WOOD)
        end
        print(string.format("Queued 20 beds at Carpenters (%d,%d,z%d) — total jobs now: %d",
            bld.centerx, bld.centery, bld.z, #bld.jobs))
        break
    end
end

-- Count existing beds
local beds_free = 0
local beds_placed = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BED then
        if item.flags.in_building then
            beds_placed = beds_placed + 1
        elseif not item.flags.forbid and not item.flags.in_job then
            beds_free = beds_free + 1
        end
    end
end
print(string.format("Current beds: %d placed, %d free", beds_placed, beds_free))
