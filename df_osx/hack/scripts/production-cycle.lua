-- Production cycle: requeue brew, crafts, check issues
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
local STONE = {{item_type=df.item_type.BOULDER, quantity=1, vector_id=df.job_item_vector_id.BOULDER, flags2={building_material=true, non_economic=true}}}

-- Requeue brew jobs on all existing stills
local brew_total = 0
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) and bld.type == df.workshop_type.Still and bld.flags.exists then
        local to_add = 5 - #bld.jobs
        if to_add > 0 then
            for i = 1, to_add do
                add_job(bld, "CustomReaction", BREW, "BREW_DRINK_FROM_PLANT")
                brew_total = brew_total + 1
            end
        end
    end
end
print(string.format("Queued %d brew jobs", brew_total))

-- Queue crafts at z96 craftsdwarfs
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) and bld.type == df.workshop_type.Craftsdwarfs and bld.flags.exists then
        if #bld.jobs < 5 then
            for i = 1, 10 do
                add_job(bld, "MakeCrafts", STONE)
            end
            print(string.format("Queued 10 crafts at (%d,%d,z%d)", bld.centerx, bld.centery, bld.z))
        end
    end
end

-- Check plants and brewable supply
local plants = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.PLANT and not item.flags.in_building and not item.flags.forbid and not item.flags.in_job and not item.flags.rotten then
        plants = plants + 1
    end
end
print(string.format("Brewable plants: %d", plants))

-- Stone on z96 for crafts
local z96_stone = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BOULDER and item.pos.z == 96 and
       not item.flags.in_building and not item.flags.forbid and not item.flags.in_job then
        z96_stone = z96_stone + 1
    end
end
print(string.format("Stone on z96: %d", z96_stone))

-- Enable stone hauling on all citizens
local stone_haulers = 0
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit) and unit.mood < 0 then
        if not unit.status.labors[df.unit_labor.HAUL_STONE] then
            unit.status.labors[df.unit_labor.HAUL_STONE] = true
            stone_haulers = stone_haulers + 1
        end
    end
end
if stone_haulers > 0 then print(string.format("Enabled stone hauling on %d dwarves", stone_haulers)) end
