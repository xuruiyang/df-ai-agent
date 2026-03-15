-- Check farm status and food production
print("=== FARMS ===")
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.FarmPlot and bld.flags.exists then
        local season = df.global.cur_season
        local plant = bld.plant_id[season]
        local pname = "NONE"
        if plant >= 0 and plant < #df.global.world.raws.plants.all then
            pname = df.global.world.raws.plants.all[plant].id
        end
        -- Check if farm is active/has crop
        print(string.format("  Farm id=%d at (%d,%d,z%d) size=%dx%d plant=%s",
            bld.id, bld.x1, bld.y1, bld.z, bld.x2-bld.x1+1, bld.y2-bld.y1+1, pname))
    end
end

-- Count plump helmets specifically
local plumps = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.PLANT and not item.flags.in_building and not item.flags.forbid and not item.flags.rotten then
        local mat = dfhack.matinfo.decode(item)
        if mat and mat.plant and mat.plant.id == "MUSHROOM_HELMET_PLUMP" then
            plumps = plumps + 1
        end
    end
end
print(string.format("\nPlump helmets available: %d", plumps))

-- Check farmers
local farmers = 0
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit) and unit.mood < 0 then
        if unit.status.labors[df.unit_labor.PLANT] then
            farmers = farmers + 1
        end
    end
end
print(string.format("Farmers (PLANT labor): %d", farmers))
if farmers < 8 then
    local added = 0
    for _, unit in ipairs(df.global.world.units.active) do
        if dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit) and unit.mood < 0 then
            if not unit.status.labors[df.unit_labor.PLANT] then
                unit.status.labors[df.unit_labor.PLANT] = true
                added = added + 1
                if added >= (8 - farmers) then break end
            end
        end
    end
    print(string.format("Enabled PLANT on %d more dwarves", added))
end

-- Check all seasons are set on farms
print("\n=== SETTING ALL FARMS TO PLUMP HELMETS ===")
local plump_id = -1
for i, plant in ipairs(df.global.world.raws.plants.all) do
    if plant.id == "MUSHROOM_HELMET_PLUMP" then plump_id = i; break end
end

for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.FarmPlot and bld.flags.exists then
        for season = 0, 3 do
            if bld.plant_id[season] ~= plump_id then
                bld.plant_id[season] = plump_id
                print(string.format("  Fixed season %d on farm %d", season, bld.id))
            end
        end
    end
end
