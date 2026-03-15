local plump_id = -1
for i, plant in ipairs(df.global.world.raws.plants.all) do
    if plant.id == "MUSHROOM_HELMET_PLUMP" then plump_id = i; break end
end
if plump_id >= 0 then
    for _, bld in ipairs(df.global.world.buildings.all) do
        if bld:getType() == df.building_type.FarmPlot and bld.flags.exists then
            for s = 0, 3 do bld.plant_id[s] = plump_id end
            print("Farm id=" .. bld.id .. " -> plump helmets all seasons")
        end
    end
else
    print("ERROR: plump helmets not found!")
end
