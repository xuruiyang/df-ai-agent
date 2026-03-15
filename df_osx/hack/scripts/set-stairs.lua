-- Directly set stair tiletypes to connect z95-z94-z93
-- z95 (94,106): set to STAIR_DOWN (tiletype 56) 
-- z94 (94,106): already STAIR_UPDOWN (tiletype 55) ✓
-- z93 (94,106): set to STAIR_UP (tiletype 54)

local function set_tile(x, y, z, tt_new)
    local block = dfhack.maps.getTileBlock(x, y, z)
    if block then
        local lx = x % 16
        local ly = y % 16
        block.tiletype[lx][ly] = tt_new
        local shape = df.tiletype.attrs[tt_new].shape
        print(string.format("  Set (%d,%d,z%d) to tiletype=%d shape=%s", x, y, z, tt_new, tostring(shape)))
    end
end

print("=== SETTING STAIRWAY ===")
set_tile(94, 106, 95, 56)  -- STAIR_DOWN
set_tile(94, 106, 93, 54)  -- STAIR_UP

-- Verify full path
print("\n=== VERIFYING STAIRWAY ===")
for z = 96, 93, -1 do
    local block = dfhack.maps.getTileBlock(94, 106, z)
    if block then
        local lx = 94 % 16
        local ly = 106 % 16
        local tt = block.tiletype[lx][ly]
        local shape = df.tiletype.attrs[tt].shape
        print(string.format("  (94,106,z%d): shape=%s (%d) tiletype=%d", z, tostring(shape), shape, tt))
    end
end

-- Also verify the main staircase for reference
print("\n=== MAIN STAIRCASE (94,100) ===")
for z = 96, 93, -1 do
    local block = dfhack.maps.getTileBlock(94, 100, z)
    if block then
        local lx = 94 % 16
        local ly = 100 % 16
        local tt = block.tiletype[lx][ly]
        local shape = df.tiletype.attrs[tt].shape
        print(string.format("  (94,100,z%d): shape=%s (%d)", z, tostring(shape), shape))
    end
end

print("\nz94 should now be accessible!")
