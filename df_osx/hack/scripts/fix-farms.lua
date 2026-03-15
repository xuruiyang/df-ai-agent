local plump_id = -1
for i, plant in ipairs(df.global.world.raws.plants.all) do
    if plant.id == "MUSHROOM_HELMET_PLUMP" then
        plump_id = i; break
    end
end
if plump_id < 0 then print("No plump helmets!"); return end

local fixed = 0
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.FarmPlot and bld.flags.exists then
        local needs = false
        for season = 0, 3 do
            if bld.plant_id[season] < 0 then needs = true end
        end
        if needs then
            for season = 0, 3 do bld.plant_id[season] = plump_id end
            fixed = fixed + 1
            print(string.format("  Fixed farm at (%d,%d)", bld.x1, bld.y1))
        end
    end
end
print(string.format("Fixed %d farms", fixed))
