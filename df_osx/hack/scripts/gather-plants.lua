-- Check farm status and count brewable plants
print("=== Farm Plot Status ===")
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_farmplotst:is_instance(bld) then
        print(string.format("  Farm at (%d,%d) size %dx%d",
            bld.x1, bld.y1,
            bld.x2 - bld.x1 + 1, bld.y2 - bld.y1 + 1))
        for season = 0, 3 do
            local season_name = ({"Spring","Summer","Autumn","Winter"})[season+1]
            local plant_id = bld.plant_id[season]
            if plant_id >= 0 then
                local plant_raw = df.global.world.raws.plants.all[plant_id]
                print(string.format("    %s: %s", season_name, plant_raw.id))
            else
                print(string.format("    %s: NONE SET", season_name))
            end
        end
    end
end

-- Count brewable plants
local brewable = 0
local plant_names = {}
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.PLANT and not item.flags.forbid and not item.flags.dump and not item.flags.in_job then
        brewable = brewable + 1
        local name = dfhack.items.getDescription(item, 0)
        plant_names[name] = (plant_names[name] or 0) + 1
    end
end
print(string.format("\nBrewable plants available: %d", brewable))
for name, ct in pairs(plant_names) do
    print(string.format("  %s: %d", name, ct))
end

-- Count drinks
local drinks = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.DRINK and not item.flags.forbid then
        drinks = drinks + item.stack_size
    end
end
print(string.format("\nDrinks: %d", drinks))

-- Count shrubs on surface
local shrub_count = 0
for _, plant in ipairs(df.global.world.plants.all) do
    if plant.pos.z == 97 and not plant.tree_info then
        shrub_count = shrub_count + 1
    end
end
print(string.format("Surface shrubs: %d", shrub_count))
