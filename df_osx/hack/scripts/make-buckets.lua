-- Count buckets and queue more
local buckets = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BUCKET then
        buckets = buckets + 1
    end
end
print(string.format("Total buckets: %d", buckets))

-- Queue buckets at carpenter
local WOOD = {{item_type=df.item_type.WOOD, quantity=1, vector_id=df.job_item_vector_id.WOOD}}
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) and bld.type == df.workshop_type.Carpenters and bld.flags.exists then
        for i = 1, 5 do
            local job = df.job:new()
            job.job_type = df.job_type.MakeBucket
            job.pos = xyz2pos(bld.centerx, bld.centery, bld.z)
            local ji = df.job_item:new()
            ji.item_type = df.item_type.WOOD
            ji.quantity = 1
            ji.vector_id = df.job_item_vector_id.WOOD
            ji.reaction_class = ""
            ji.has_material_reaction_product = ""
            job.job_items:insert('#', ji)
            dfhack.job.linkIntoWorld(job)
            bld.jobs:insert('#', job)
            job.general_refs:insert('#', {new=df.general_ref_building_holderst, building_id=bld.id})
        end
        print("Queued 5 buckets at Carpenters")
        break
    end
end

-- Check for injured/resting dwarves
print("\n=== INJURED/RESTING ===")
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit) then
        if #unit.body.wounds > 0 or unit.counters.unconscious > 0 then
            local name = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
            print(string.format("  %s wounds=%d unconscious=%d", name, #unit.body.wounds, unit.counters.unconscious))
        end
    end
end
