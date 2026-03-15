-- Check tile material at farm area
for y = 90, 95 do
    local block = dfhack.maps.getTileBlock(86, y, 96)
    if block then
        local lx = 86 % 16
        local ly = y % 16
        local tt = block.tiletype[lx][ly]
        local attrs = df.tiletype.attrs[tt]
        local shape = df.tiletype_shape[attrs.shape] or "?"
        local mat = df.tiletype_material[attrs.material] or "?"
        print(string.format("  (86,%d,96): shape=%s mat=%s tt=%d", y, shape, mat, tt))
    end
end

-- Check what z-level has soil
print("\nChecking layers:")
for z = 95, 99 do
    local block = dfhack.maps.getTileBlock(86, 90, z)
    if block then
        local tt = block.tiletype[86%16][90%16]
        local attrs = df.tiletype.attrs[tt]
        print(string.format("  z=%d: shape=%s mat=%s", z, 
            df.tiletype_shape[attrs.shape] or "?", 
            df.tiletype_material[attrs.material] or "?"))
    end
end

-- Try farm placement
print("\nFarm construction test:")
local pos = xyz2pos(86, 90, 96)
local bld = dfhack.buildings.allocInstance(pos, df.building_type.FarmPlot, -1, -1)
if bld then
    bld.x1 = 86; bld.x2 = 89; bld.y1 = 90; bld.y2 = 93
    print("Allocated, needsItems=" .. tostring(dfhack.buildings.needsItems(bld)))
    -- Check if tiles are valid for farm
    local ok = dfhack.buildings.checkFreeTiles(bld, bld:getSize(), nil, false, false)
    print("checkFreeTiles=" .. tostring(ok))
end
