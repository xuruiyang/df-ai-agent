-- Check stairway connectivity from z96 down to z93
print("=== STAIR ACCESS ===")
for z = 97, 91, -1 do
    -- Check at (95,95) — our standard stair location
    local block = dfhack.maps.getTileBlock(95, 95, z)
    if block then
        local lx = 95 % 16
        local ly = 95 % 16
        local tt = block.tiletype[lx][ly]
        local shape = df.tiletype.attrs[tt].shape
        print(string.format("  z%d (95,95): shape=%s tiletype=%d", z, tostring(shape), tt))
    end
end

-- Also check the main staircase location from build-all (might be different)
print("\n=== CHECKING OTHER STAIR LOCATIONS ===")
-- Check around (94-96, 99-101) for stairs
for x = 93, 97 do
    for y = 98, 102 do
        for z = 96, 93, -1 do
            local block = dfhack.maps.getTileBlock(x, y, z)
            if block then
                local lx = x % 16
                local ly = y % 16
                local tt = block.tiletype[lx][ly]
                local shape = df.tiletype.attrs[tt].shape
                if shape == df.tiletype_shape.STAIR_DOWN or 
                   shape == df.tiletype_shape.STAIR_UP or
                   shape == df.tiletype_shape.STAIR_UPDOWN then
                    print(string.format("  (%d,%d,z%d): %s", x, y, z, tostring(shape)))
                end
            end
        end
    end
end
