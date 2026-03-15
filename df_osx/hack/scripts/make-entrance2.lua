-- Dig entrance AWAY from the wagon (wagon at 89-91, 100-102)
-- Try position (93, 100, z97) - east of wagon
local x, y, z = 93, 100, 97
local block = dfhack.maps.getTileBlock(x, y, z)
if block then
    local lx = x % 16
    local ly = y % 16
    local tt = block.tiletype[lx][ly]
    local attrs = df.tiletype.attrs[tt]
    local shape_name = df.tiletype_shape[attrs.shape] or "?"
    local mat_name = df.tiletype_material[attrs.material] or "?"
    print(string.format("Tile (%d,%d,%d): shape=%s mat=%s", x, y, z, shape_name, mat_name))
    
    block.designation[lx][ly].dig = df.tile_dig_designation.DownStair
    block.flags.designated = true
    print(string.format("Set DownStair, dig=%d, designated=%s", 
        block.designation[lx][ly].dig, tostring(block.flags.designated)))
end

-- Also set z96 stair
local block96 = dfhack.maps.getTileBlock(93, 100, 96)
if block96 then
    block96.designation[93 % 16][100 % 16].dig = df.tile_dig_designation.UpDownStair
    block96.flags.designated = true
    print("Set UpDownStair at (93,100,96)")
end
