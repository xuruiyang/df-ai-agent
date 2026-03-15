-- Carve a path from (94,100,z94) to wall at (94,106,z94) and make a stair there
-- First, dig a corridor from current floor to the wall
-- Tiles (94,101) through (94,105) should be floor already or wall

-- Check each tile
print("=== PATH TO WALL ===")
for y = 100, 107 do
    local block = dfhack.maps.getTileBlock(94, y, 94)
    if block then
        local lx = 94 % 16
        local ly = y % 16
        local tt = block.tiletype[lx][ly]
        local shape = df.tiletype.attrs[tt].shape
        print(string.format("  (94,%d,z94): %s", y, tostring(shape)))
        
        -- Designate walls for digging
        if shape == df.tiletype_shape.WALL then
            if y == 106 then
                -- This is where we want the stair
                block.designation[lx][ly].dig = df.tile_dig_designation.UpDownStair
            else
                block.designation[lx][ly].dig = df.tile_dig_designation.Default
            end
            block.flags.designated = true
        end
    end
end

-- Also need to connect z95 and z93 to (94,106)
-- z95: designate down stair at (94,106)
local block95 = dfhack.maps.getTileBlock(94, 106, 95)
if block95 then
    local lx = 94 % 16
    local ly = 106 % 16
    local tt = block95.tiletype[lx][ly]
    local shape = df.tiletype.attrs[tt].shape
    print(string.format("\n(94,106,z95): %s", tostring(shape)))
    if shape == df.tiletype_shape.WALL then
        block95.designation[lx][ly].dig = df.tile_dig_designation.DownStair
        block95.flags.designated = true
        print("Designated down stair at (94,106,z95)")
    end
end

-- z93: designate up stair at (94,106) 
local block93 = dfhack.maps.getTileBlock(94, 106, 93)
if block93 then
    local lx = 94 % 16
    local ly = 106 % 16
    local tt = block93.tiletype[lx][ly]
    local shape = df.tiletype.attrs[tt].shape
    print(string.format("(94,106,z93): %s", tostring(shape)))
    if shape == df.tiletype_shape.WALL then
        block93.designation[lx][ly].dig = df.tile_dig_designation.UpStair
        block93.flags.designated = true
        print("Designated up stair at (94,106,z93)")
    end
end

print("\nDesignations set. Using dig-now to carve instantly...")
