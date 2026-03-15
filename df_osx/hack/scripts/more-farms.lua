-- Build farm plots - exact same pattern as build-all.lua
local z = 96

local function build_farm(x1, y1, x2, y2, z)
    local pos = xyz2pos(x1, y1, z)
    local bld = dfhack.buildings.allocInstance(pos, df.building_type.FarmPlot, -1, -1)
    if not bld then print("Failed farm alloc"); return end
    bld.x1 = x1; bld.x2 = x2; bld.y1 = y1; bld.y2 = y2
    local ok = pcall(function() dfhack.buildings.constructWithFilters(bld, {}) end)
    if ok then
        print(string.format("Farm at (%d,%d)-(%d,%d) z%d id=%d", x1,y1,x2,y2,z, bld.id))
    else
        print("Farm FAILED")
    end
end

-- New farms next to existing ones
build_farm(93, 88, 96, 91, z)  -- Farm 3
build_farm(93, 92, 96, 95, z)  -- Farm 4

-- Set plump helmets on new farms
local plump_id = -1
for i, plant in ipairs(df.global.world.raws.plants.all) do
    if plant.id == "MUSHROOM_HELMET_PLUMP" then
        plump_id = i
        break
    end
end

if plump_id >= 0 then
    for _, bld in ipairs(df.global.world.buildings.all) do
        if bld:getType() == df.building_type.FarmPlot and bld.flags.exists then
            local needs_set = false
            for season = 0, 3 do
                if bld.plant_id[season] < 0 then needs_set = true end
            end
            if needs_set then
                for season = 0, 3 do
                    bld.plant_id[season] = plump_id
                end
                print("Set plump helmets on farm id=" .. bld.id)
            end
        end
    end
end
