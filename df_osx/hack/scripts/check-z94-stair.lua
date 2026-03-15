-- Detailed check of (94,100,z94) stair
local block = dfhack.maps.getTileBlock(94, 100, 94)
if block then
    local lx = 94 % 16
    local ly = 100 % 16
    local tt = block.tiletype[lx][ly]
    print(string.format("Tiletype: %d", tt))
    print(string.format("Shape: %s", tostring(df.tiletype.attrs[tt].shape)))
    print(string.format("Material: %s", tostring(df.tiletype.attrs[tt].material)))
    local occ = block.occupancy[lx][ly]
    print(string.format("Building: %d", occ.building))
end

-- Check if there's a construction building here
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.Construction and bld.x1 == 94 and bld.y1 == 100 and bld.z == 94 then
        print(string.format("Construction building found! id=%d exists=%s", bld.id, tostring(bld.flags.exists)))
    end
end

-- Try dig-now at this position
print("\nAttempting dig-now...")
