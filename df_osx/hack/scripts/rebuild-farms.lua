-- List all farm plots first
print("=== EXISTING FARMS ===")
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.FarmPlot then
        print(string.format("  Farm id=%d at (%d,%d)-(%d,%d) z%d exists=%s",
            bld.id, bld.x1, bld.y1, bld.x2, bld.y2, bld.z, tostring(bld.flags.exists)))
    end
end

-- Check floor at (97,88,z96)
local block = dfhack.maps.getTileBlock(97, 88, 96)
if block then
    local lx = 97 % 16
    local ly = 88 % 16
    local tt = block.tiletype[lx][ly]
    print(string.format("\n(97,88,z96): shape=%s tiletype=%d", tostring(df.tiletype.attrs[tt].shape), tt))
end

-- Check if z96 has mud/soil at these positions (farms need subterranean soil/mud)
-- Subterranean farms need muddy stone floor to plant
local b2 = dfhack.maps.getTileBlock(97, 88, 96)
if b2 then
    local lx = 97 % 16
    local ly = 88 % 16
    local mat = df.tiletype.attrs[b2.tiletype[lx][ly]].material
    print(string.format("Material at (97,88,z96): %s", tostring(mat)))
    -- Check designation for muddy
    local desig = b2.designation[lx][ly]
    print(string.format("Subterranean: %s", tostring(desig.subterranean)))
end

-- Try to build farm again
print("\n=== REBUILDING FARM ===")
local pos = xyz2pos(97, 88, 96)
local bld = dfhack.buildings.allocInstance(pos, df.building_type.FarmPlot, -1, -1)
if bld then
    bld.x1 = 97; bld.x2 = 100; bld.y1 = 88; bld.y2 = 91
    local ok, err = pcall(function() dfhack.buildings.constructWithFilters(bld, {}) end)
    if ok then
        print(string.format("Built farm id=%d", bld.id))
        for season = 0, 3 do bld.plant_id[season] = 173 end  -- pig tails
        print("Set to pig tails")
    else
        print("Failed: " .. tostring(err))
    end
else
    print("Alloc failed")
end
