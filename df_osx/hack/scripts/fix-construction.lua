-- Check suspended constructions and resume them
print("=== SUSPENDED BUILDINGS ===")
for _, bld in ipairs(df.global.world.buildings.all) do
    if not bld.flags.exists then
        local btype = df.building_type[bld:getType()]
        print(string.format("  %s at (%d,%d,z%d) id=%d — not yet built", btype, bld.x1, bld.y1, bld.z, bld.id))
        -- Check if construction jobs are suspended
        for _, job in ipairs(bld.jobs) do
            if job.flags.suspend then
                job.flags.suspend = false
                print(string.format("    Resumed suspended job: %s", tostring(job.job_type)))
            end
        end
    end
end

-- Enable MASON labor on more dwarves for construction
local masons = 0
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit) and unit.mood < 0 then
        if unit.status.labors[df.unit_labor.MASON] then masons = masons + 1 end
    end
end
print(string.format("\nMasons: %d", masons))
if masons < 4 then
    local added = 0
    for _, unit in ipairs(df.global.world.units.active) do
        if dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit) and unit.mood < 0 then
            if not unit.status.labors[df.unit_labor.MASON] then
                unit.status.labors[df.unit_labor.MASON] = true
                added = added + 1
                if added >= (4 - masons) then break end
            end
        end
    end
    print(string.format("Enabled MASON on %d more dwarves", added))
end

-- Enable ARCHITECT labor for construction
local architects = 0
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit) and unit.mood < 0 then
        if unit.status.labors[df.unit_labor.ARCHITECT] then architects = architects + 1 end
    end
end
print(string.format("Architects: %d", architects))
if architects < 2 then
    local added = 0
    for _, unit in ipairs(df.global.world.units.active) do
        if dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit) and unit.mood < 0 then
            if not unit.status.labors[df.unit_labor.ARCHITECT] then
                unit.status.labors[df.unit_labor.ARCHITECT] = true
                added = added + 1
                if added >= (2 - architects) then break end
            end
        end
    end
    print(string.format("Enabled ARCHITECT on %d more dwarves", added))
end

-- Queue more coffins at mason
print("\n=== COFFIN QUEUE ===")
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) and bld.type == df.workshop_type.Masons and bld.flags.exists then
        -- Count coffin jobs already queued
        local coffin_jobs = 0
        for _, job in ipairs(bld.jobs) do
            if job.job_type == df.job_type.ConstructCoffin then coffin_jobs = coffin_jobs + 1 end
        end
        local needed = 5 - coffin_jobs
        if needed > 0 then
            for i = 1, needed do
                local job = df.job:new()
                job.job_type = df.job_type.ConstructCoffin
                job.pos = xyz2pos(bld.centerx, bld.centery, bld.z)
                local ji = df.job_item:new()
                ji.item_type = df.item_type.BOULDER
                ji.quantity = 1
                ji.vector_id = df.job_item_vector_id.BOULDER
                ji.flags2.building_material = true
                ji.flags2.non_economic = true
                ji.reaction_class = ""
                ji.has_material_reaction_product = ""
                job.job_items:insert('#', ji)
                dfhack.job.linkIntoWorld(job)
                bld.jobs:insert('#', job)
                job.general_refs:insert('#', {new=df.general_ref_building_holderst, building_id=bld.id})
            end
            print(string.format("Queued %d more coffins at Mason", needed))
        else
            print("Coffin jobs already queued")
        end
    end
end
