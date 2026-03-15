-- Find dead dwarves
print("=== DEAD DWARVES ===")
for _, unit in ipairs(df.global.world.units.all) do
    if unit.race == df.global.ui.race_id and not dfhack.units.isAlive(unit) then
        local name = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
        if name ~= "" then
            print(string.format("  %s id=%d", name, unit.id))
        end
    end
end

-- Place coffin as tomb for Urdim and Mafol
-- Find free coffin
local coffin = nil
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.COFFIN and not item.flags.in_building and not item.flags.forbid and not item.flags.in_job then
        coffin = item
        break
    end
end

if coffin then
    -- Place coffin at an empty spot on z96
    local placed = false
    for x = 100, 110 do
        if placed then break end
        for y = 100, 110 do
            local block = dfhack.maps.getTileBlock(x, y, 96)
            if block then
                local lx = x % 16
                local ly = y % 16
                local tt = block.tiletype[lx][ly]
                if df.tiletype.attrs[tt].shape == df.tiletype_shape.FLOOR and block.occupancy[lx][ly].building == 0 then
                    local pos = xyz2pos(x, y, 96)
                    local bld = dfhack.buildings.allocInstance(pos, df.building_type.Coffin, -1, -1)
                    if bld then
                        local ok = pcall(function()
                            dfhack.buildings.constructWithItems(bld, {coffin})
                        end)
                        if ok then
                            bld.is_room = true
                            print(string.format("Placed coffin at (%d,%d,z96) id=%d", x, y, bld.id))
                            placed = true
                        end
                    end
                    break
                end
            end
        end
    end
else
    print("No free coffins available!")
end

-- Queue slabs and coffins at mason
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) and bld.type == df.workshop_type.Masons and bld.flags.exists then
        local STONE = {item_type=df.item_type.BOULDER, quantity=1, vector_id=df.job_item_vector_id.BOULDER,
            flags2={building_material=true, non_economic=true}}
        for _, jtype in ipairs({df.job_type.ConstructSlab, df.job_type.ConstructSlab, df.job_type.ConstructSlab,
                                df.job_type.ConstructCoffin, df.job_type.ConstructCoffin, df.job_type.ConstructCoffin}) do
            local job = df.job:new()
            job.job_type = jtype
            job.pos = xyz2pos(bld.centerx, bld.centery, bld.z)
            local ji = df.job_item:new()
            ji.item_type = STONE.item_type; ji.quantity = STONE.quantity; ji.vector_id = STONE.vector_id
            ji.flags2.building_material = true; ji.flags2.non_economic = true
            ji.reaction_class = ""; ji.has_material_reaction_product = ""
            job.job_items:insert('#', ji)
            dfhack.job.linkIntoWorld(job)
            bld.jobs:insert('#', job)
            job.general_refs:insert('#', {new=df.general_ref_building_holderst, building_id=bld.id})
        end
        print("Queued 3 slabs + 3 coffins at Mason")
        break
    end
end
