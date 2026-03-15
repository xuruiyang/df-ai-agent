-- Fix z94 access by channeling from z95 and designating stair
-- Option 1: Channel at (93,100,z95) to create a ramp down to z94
-- Then dig up/down stair at (93,100,z94)

-- Actually, let's try dig-now to instantly carve the stair at (94,100,z94)
-- First verify the designation was set
local block = dfhack.maps.getTileBlock(94, 100, 94)
if block then
    local lx = 94 % 16
    local ly = 100 % 16
    local dig = block.designation[lx][ly].dig
    print(string.format("Designation at (94,100,z94): %d", dig))
end

-- The z95 has STAIR_UPDOWN at (94,100) which can go down
-- The z93 has STAIR_UP at (94,100) which can go up
-- We just need z94 to have STAIR_UPDOWN to connect them
-- But z94 has a FLOOR tile, and you can't designate stair carving on a floor

-- Alternative: channel from above
-- Channel at (94,100,z95) would remove the floor and create access
-- But that would destroy our z95 stair! Bad idea.

-- Better: dig a new connection point
-- Find a WALL tile adjacent to the z94 area and dig a stair there
-- Check (93,100,z94) and (95,100,z94)
for _, xy in ipairs({{93,100}, {95,100}, {94,99}, {94,101}}) do
    local x, y = xy[1], xy[2]
    local b = dfhack.maps.getTileBlock(x, y, 94)
    if b then
        local lx2 = x % 16
        local ly2 = y % 16
        local tt = b.tiletype[lx2][ly2]
        local shape = df.tiletype.attrs[tt].shape
        print(string.format("  (%d,%d,z94): shape=%s", x, y, tostring(shape)))
    end
end

-- Actually, let's just use dig-now as a practical solution
-- It will carve the designated stair instantly
print("\nUsing dig-now to create the stair...")
