-- Fix stairway gap at z94
-- Need to connect z95 to z94 at (94,100)

-- Check what's at (94,100,z94)
local block94 = dfhack.maps.getTileBlock(94, 100, 94)
if block94 then
    local lx = 94 % 16
    local ly = 100 % 16
    local tt = block94.tiletype[lx][ly]
    local shape = df.tiletype.attrs[tt].shape
    print(string.format("(94,100,z94): shape=%s tiletype=%d", tostring(shape), tt))
    
    if shape == df.tiletype_shape.WALL then
        -- Designate up/down stair
        block94.designation[lx][ly].dig = df.tile_dig_designation.UpDownStair
        block94.flags.designated = true
        print("Designated up/down stair at (94,100,z94)")
    elseif shape == df.tiletype_shape.FLOOR then
        -- Floor exists, need to channel or build a stair
        -- Actually if there's floor, we can build a constructed stair
        -- Or designate a channel from z93 below
        print("Floor at z94 — need to build constructed stair or channel")
        -- Try designating up/down stair (works on floor sometimes)
        block94.designation[lx][ly].dig = df.tile_dig_designation.UpDownStair
        block94.flags.designated = true
        print("Designated up/down stair at (94,100,z94)")
    else
        print(string.format("Already a stair shape: %s", tostring(shape)))
    end
end

-- Also check z95 at (94,100) — make sure it has down component
local block95 = dfhack.maps.getTileBlock(94, 100, 95)
if block95 then
    local lx = 94 % 16
    local ly = 100 % 16
    local tt = block95.tiletype[lx][ly]
    local shape = df.tiletype.attrs[tt].shape
    print(string.format("(94,100,z95): shape=%s tiletype=%d", tostring(shape), tt))
end

-- Check z93 at (94,100)
local block93 = dfhack.maps.getTileBlock(94, 100, 93)
if block93 then
    local lx = 94 % 16
    local ly = 100 % 16
    local tt = block93.tiletype[lx][ly]
    local shape = df.tiletype.attrs[tt].shape
    print(string.format("(94,100,z93): shape=%s tiletype=%d", tostring(shape), tt))
end

-- Also search for any existing stairway on z94
print("\n=== SEARCHING FOR STAIRS ON z94 ===")
local found = false
for x = 80, 110 do
    for y = 80, 110 do
        local block = dfhack.maps.getTileBlock(x, y, 94)
        if block then
            local lx = x % 16
            local ly = y % 16
            local tt = block.tiletype[lx][ly]
            local shape = df.tiletype.attrs[tt].shape
            if shape == df.tiletype_shape.STAIR_DOWN or 
               shape == df.tiletype_shape.STAIR_UP or
               shape == df.tiletype_shape.STAIR_UPDOWN then
                print(string.format("  Stair at (%d,%d,z94): %s", x, y, tostring(shape)))
                found = true
            end
        end
    end
end
if not found then print("  NO stairs found on z94!") end
