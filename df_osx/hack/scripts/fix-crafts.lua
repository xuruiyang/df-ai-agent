-- Check and fix stone crafting labor
print("=== STONE_CRAFT LABOR ===")
local has_crafter = false
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit) and unit.mood < 0 then
        if unit.status.labors[df.unit_labor.STONE_CRAFT] then
            local name = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
            print(string.format("  %s has STONE_CRAFT", name))
            has_crafter = true
        end
    end
end

if not has_crafter then
    print("  No one has STONE_CRAFT labor! Enabling on some dwarves...")
    local count = 0
    for _, unit in ipairs(df.global.world.units.active) do
        if dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit) and unit.mood < 0 then
            if count < 3 then
                unit.status.labors[df.unit_labor.STONE_CRAFT] = true
                local name = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
                print(string.format("  Enabled STONE_CRAFT on %s", name))
                count = count + 1
            end
        end
    end
end

-- Re-queue crafts
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

local STONE = {{item_type=df.item_type.BOULDER, quantity=1, vector_id=df.job_item_vector_id.BOULDER, flags2={building_material=true, non_economic=true}}}

for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) and bld.type == df.workshop_type.Craftsdwarfs then
        if #bld.jobs == 0 then
            for i = 1, 15 do
                add_job(bld, "MakeCrafts", STONE)
            end
            print("Queued 15 stone craft jobs")
        else
            print(string.format("Craftsdwarfs already has %d jobs", #bld.jobs))
        end
    end
end
