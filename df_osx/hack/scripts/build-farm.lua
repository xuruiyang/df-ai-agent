-- Farm plots need constructWithFilters with empty item list
local function build_farm(x1, y1, x2, y2, z)
    local pos = xyz2pos(x1, y1, z)
    local bld = dfhack.buildings.allocInstance(pos, df.building_type.FarmPlot, -1, -1)
    if not bld then
        print("Failed to allocate farm")
        return
    end
    bld.x1 = x1; bld.x2 = x2; bld.y1 = y1; bld.y2 = y2
    local ok, err = pcall(function() return dfhack.buildings.constructWithFilters(bld, {}) end)
    print(string.format("Farm (%d,%d)-(%d,%d) z%d: pcall=%s result=%s", x1, y1, x2, y2, z, tostring(ok), tostring(err)))
end

build_farm(86, 90, 89, 93, 96)
build_farm(86, 94, 89, 97, 96)

-- Check buildings list
print("\nAll buildings:")
for _, bld in ipairs(df.global.world.buildings.all) do
    local btype = df.building_type[bld:getType()] or "?"
    print(string.format("  id=%d type=%s at (%d,%d,%d)-(%d,%d)", 
        bld.id, btype, bld.x1, bld.y1, bld.z, bld.x2, bld.y2))
end
