-- Fix ghost: we need to memorialize or bury the dead
-- Check coffins
local coffins_free = 0
local coffins_placed = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.COFFIN then
        if item.flags.in_building then coffins_placed = coffins_placed + 1
        elseif not item.flags.forbid and not item.flags.in_job then coffins_free = coffins_free + 1
        end
    end
end
print(string.format("Coffins: %d placed, %d free", coffins_placed, coffins_free))

-- Find dead dwarves (for memorial/burial)
print("\n=== DEAD DWARVES ===")
for _, unit in ipairs(df.global.world.units.all) do
    if unit.race == df.global.ui.race_id and not dfhack.units.isAlive(unit) then
        local name = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
        if name ~= "" then
            print(string.format("  %s id=%d ghost=%s", name, unit.id, tostring(unit.flags1.dead)))
        end
    end
end

-- Build memorial slab to appease ghost
-- First, queue slabs at mason
print("\n=== QUEUING MEMORIAL SLABS ===")
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) and bld.type == df.workshop_type.Masons and bld.flags.exists then
        -- Queue 3 memorial slabs
        for i = 1, 3 do
            local job = df.job:new()
            job.job_type = df.job_type.ConstructSlab
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
        print("Queued 3 memorial slabs at Mason")
        
        -- Also queue more coffins
        for i = 1, 5 do
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
        print("Queued 5 coffins at Mason")
        break
    end
end
