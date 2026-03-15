-- Add correct MakeCharcoal jobs to wood furnace
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_furnacest:is_instance(bld) and bld.type == df.furnace_type.WoodFurnace and bld.flags.exists then
        -- Add MakeCharcoal jobs
        for i = 1, 5 do
            local job = df.job:new()
            job.job_type = df.job_type.MakeCharcoal
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
        print(string.format("Added 5 MakeCharcoal jobs at WoodFurnace (%d,%d,z%d) — total jobs: %d",
            bld.centerx, bld.centery, bld.z, #bld.jobs))
    end
end

-- Also add correct SmeltOre jobs to smelter
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_furnacest:is_instance(bld) and bld.type == df.furnace_type.Smelter and bld.flags.exists then
        if #bld.jobs < 3 then
            for i = 1, 3 do
                local job = df.job:new()
                job.job_type = df.job_type.SmeltOre
                job.pos = xyz2pos(bld.centerx, bld.centery, bld.z)
                -- Fuel (charcoal bar)
                local ji1 = df.job_item:new()
                ji1.item_type = df.item_type.BAR
                ji1.quantity = 1
                ji1.vector_id = df.job_item_vector_id.BAR
                ji1.reaction_class = ""
                ji1.has_material_reaction_product = ""
                -- Ore (boulder)
                local ji2 = df.job_item:new()
                ji2.item_type = df.item_type.BOULDER
                ji2.quantity = 1
                ji2.vector_id = df.job_item_vector_id.BOULDER
                ji2.reaction_class = ""
                ji2.has_material_reaction_product = ""
                job.job_items:insert('#', ji1)
                job.job_items:insert('#', ji2)
                dfhack.job.linkIntoWorld(job)
                bld.jobs:insert('#', job)
                job.general_refs:insert('#', {new=df.general_ref_building_holderst, building_id=bld.id})
            end
            print(string.format("Added 3 SmeltOre jobs at Smelter (%d,%d,z%d)", bld.centerx, bld.centery, bld.z))
        end
    end
end
