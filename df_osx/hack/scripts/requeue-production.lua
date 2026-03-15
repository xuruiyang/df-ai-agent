-- Queue brew jobs on both stills and more furniture at workshops
local BREW = {
    {item_type=df.item_type.PLANT, quantity=1, vector_id=df.job_item_vector_id.ANY_COOKABLE},
    {item_type=df.item_type.BARREL, quantity=1, vector_id=df.job_item_vector_id.BARREL},
}
local WOOD = {{item_type=df.item_type.WOOD, quantity=1, vector_id=df.job_item_vector_id.WOOD}}
local STONE = {{item_type=df.item_type.BOULDER, quantity=1, vector_id=df.job_item_vector_id.BOULDER, flags2={building_material=true, non_economic=true}}}

local function add_job(bld, job_type, mat_specs, reaction)
    local job = df.job:new()
    job.job_type = df.job_type[job_type]
    if reaction then
        job.reaction_name = reaction
    end
    job.pos = {x=bld.centerx, y=bld.centery, z=bld.z}
    for _, spec in ipairs(mat_specs) do
        local ji = df.job_item:new()
        ji.item_type = spec.item_type
        ji.quantity = spec.quantity
        ji.vector_id = spec.vector_id
        if spec.flags2 then
            for k, v in pairs(spec.flags2) do
                ji.flags2[k] = v
            end
        end
        ji.reaction_class = ""
        ji.has_material_reaction_product = ""
        job.job_items:insert('#', ji)
    end
    dfhack.job.linkIntoWorld(job)
    bld.jobs:insert('#', job)
    job.general_refs:insert('#', {new=df.general_ref_building_holderst, building_id=bld.id})
    return job
end

local stills = {}
local carpenters = {}
local masons = {}

-- Find workshops by position (known locations)
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) then
        local cx, cy = bld.centerx, bld.centery
        -- Still underground at (90,104,z96) -> center (91,105)
        -- Still surface at (97,96,z97) -> center (98,97)
        if (cx == 91 and cy == 105) or (cx == 98 and cy == 97) then
            table.insert(stills, bld)
        -- Carpenters at (90,107,z96) -> center (91,108)
        elseif cx == 91 and cy == 108 then
            table.insert(carpenters, bld)
        -- Masons at (94,104,z96) -> center (95,105)
        elseif cx == 95 and cy == 105 then
            table.insert(masons, bld)
        end
    end
end

print(string.format("Found %d stills, %d carpenters, %d masons", #stills, #carpenters, #masons))

-- Queue 10 brew jobs on each still
for _, still in ipairs(stills) do
    for i = 1, 10 do
        add_job(still, "CustomReaction", BREW, "BREW_DRINK_FROM_PLANT")
    end
    print(string.format("  Queued 10 brew jobs on still at (%d,%d)", still.centerx, still.centery))
end

-- Queue tables and chairs at mason
for _, mason in ipairs(masons) do
    for i = 1, 4 do
        add_job(mason, "ConstructTable", STONE)
    end
    for i = 1, 4 do
        add_job(mason, "ConstructThrone", STONE)
    end
    print("  Queued 4 tables + 4 chairs at mason")
end

-- Queue barrels at carpenter
for _, carp in ipairs(carpenters) do
    for i = 1, 10 do
        add_job(carp, "MakeBarrel", WOOD)
    end
    print("  Queued 10 barrels at carpenter")
end
