-- Check construction_type enum values
print("construction_type values:")
for i = -1, 10 do
    local name = df.construction_type[i]
    if name then print(string.format("  %d = %s", i, name)) end
end

-- Check tiletype_shape enum  
print("\ntiletype_shape values:")
for i = 0, 15 do
    local name = df.tiletype_shape[i]
    if name then print(string.format("  %d = %s", i, name)) end
end

-- What shape is at (94,100,z94)?
local block = dfhack.maps.getTileBlock(94, 100, 94)
if block then
    local lx = 94 % 16
    local ly = 100 % 16
    local tt = block.tiletype[lx][ly]
    local shape = df.tiletype.attrs[tt].shape
    print(string.format("\n(94,100,z94) tiletype=%d shape=%s (%d)", tt, tostring(shape), shape))
end
