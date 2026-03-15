-- Find the farm plot and set plump helmets for all seasons
local farm = nil
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.FarmPlot then
        farm = bld
        break
    end
end

if not farm then
    print("No farm plot found!")
    return
end

print(string.format("Farm plot id=%d at (%d,%d)-(%d,%d) z%d constructed=%s",
    farm.id, farm.x1, farm.y1, farm.x2, farm.y2, farm.z, tostring(farm.flags.exists)))

if not farm.flags.exists then
    print("Farm not constructed yet!")
    return
end

-- Find plump helmet plant index
local plump_id = -1
for i, plant in ipairs(df.global.world.raws.plants.all) do
    if plant.id == "MUSHROOM_HELMET_PLUMP" then
        plump_id = i
        print("Found plump helmet at plant index: " .. i)
        break
    end
end

if plump_id < 0 then
    print("Plump helmets not found in plant raws!")
    -- List some plants for debugging
    for i = 0, 10 do
        print(string.format("  Plant %d: %s", i, df.global.world.raws.plants.all[i].id))
    end
    return
end

-- Set plump helmets for all 4 seasons
for season = 0, 3 do
    farm.plant_id[season] = plump_id
    print(string.format("Set season %d to plump helmets (id=%d)", season, plump_id))
end

print("Farm plot configured for year-round plump helmet growing!")
