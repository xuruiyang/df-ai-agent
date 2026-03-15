-- Queue stone crafts for trade at Craftsdwarfs workshop
local STONE = {{item_type=df.item_type.BOULDER, quantity=1, vector_id=df.job_item_vector_id.BOULDER, flags2={building_material=true, non_economic=true}}}
local BREW = {
    {item_type=df.item_type.PLANT, quantity=1, vector_id=df.job_item_vector_id.ANY_COOKABLE},
    {item_type=df.item_type.BARREL, quantity=1, vector_id=df.job_item_vector_id.BARREL},
}

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

-- Find Craftsdwarfs workshop (center at 95,108)
local crafts_ws
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) then
        if bld.centerx == 95 and bld.centery == 108 then
            crafts_ws = bld
        end
    end
end

if crafts_ws then
    -- Queue 15 stone crafts for trade
    for i = 1, 15 do
        add_job(crafts_ws, "MakeCrafts", STONE)
    end
    print("Queued 15 stone crafts at Craftsdwarfs workshop")
else
    print("Craftsdwarfs workshop not found!")
end

-- Also queue more brew jobs on stills
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) then
        if (bld.centerx == 91 and bld.centery == 105) or
           (bld.centerx == 98 and bld.centery == 97) then
            for i = 1, 5 do
                add_job(bld, "CustomReaction", BREW, "BREW_DRINK_FROM_PLANT")
            end
            print(string.format("Queued 5 brew jobs on still at (%d,%d)", bld.centerx, bld.centery))
        end
    end
end
