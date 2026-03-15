-- Set down stair designation at (90, 100, 97) and mark block
local x, y, z = 90, 100, 97
local block = dfhack.maps.getTileBlock(x, y, z)
if block then
    local lx = x % 16
    local ly = y % 16
    -- Set channel designation (works on any surface floor)
    block.designation[lx][ly].dig = df.tile_dig_designation.Channel
    block.flags.designated = true
    print(string.format("Set Channel at (%d,%d,%d), designated flag=%s, dig=%d",
        x, y, z, tostring(block.flags.designated), block.designation[lx][ly].dig))
    
    -- Also set down stair at a second position as backup
    local x2, y2 = 91, 100
    local lx2 = x2 % 16
    local ly2 = y2 % 16
    block.designation[lx2][ly2].dig = df.tile_dig_designation.DownStair
    print(string.format("Set DownStair at (%d,%d,%d), dig=%d",
        x2, y2, z, block.designation[lx2][ly2].dig))
end

-- Also set up/down stairs on z96 at same positions
local block96 = dfhack.maps.getTileBlock(90, 100, 96)
if block96 then
    block96.designation[90 % 16][100 % 16].dig = df.tile_dig_designation.UpDownStair
    block96.flags.designated = true
    print(string.format("Set UpDownStair at (90,100,96), flag=%s", tostring(block96.flags.designated)))
    
    block96.designation[91 % 16][100 % 16].dig = df.tile_dig_designation.UpStair
    print("Set UpStair at (91,100,96)")
end
