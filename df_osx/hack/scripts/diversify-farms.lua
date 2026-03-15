-- Set different crops on new farms for diversity
-- Farm 7 (97,88): pig tails -> ale
-- Farm 8 (97,92): sweet pods -> rum
-- Keep originals as plump helmets

local crop_ids = {}
for i, plant in ipairs(df.global.world.raws.plants.all) do
    if plant.id == "MUSHROOM_HELMET_PLUMP" then crop_ids.plump = i end
    if plant.id == "GRASS_TAIL_PIG" then crop_ids.pigtail = i end
    if plant.id == "POD_SWEET" then crop_ids.sweet = i end
    if plant.id == "GRASS_WHEAT_CAVE" then crop_ids.wheat = i end
end

print("Crop IDs:")
for name, id in pairs(crop_ids) do
    print(string.format("  %s = %d", name, id))
end

-- Set new farms to different crops
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.FarmPlot then
        if bld.x1 == 97 and bld.y1 == 88 then
            -- Farm 7: pig tails
            for season = 0, 3 do bld.plant_id[season] = crop_ids.pigtail end
            print("Farm 7 (97,88): set to pig tails")
        elseif bld.x1 == 97 and bld.y1 == 92 then
            -- Farm 8: sweet pods
            for season = 0, 3 do bld.plant_id[season] = crop_ids.sweet end
            print("Farm 8 (97,92): set to sweet pods")
        end
    end
end
