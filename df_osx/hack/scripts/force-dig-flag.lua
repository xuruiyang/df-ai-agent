-- Directly set designated flag on blocks with dig designations
-- and verify it stays set
local blocks_with_digs = {}
for _, block in ipairs(df.global.world.map.map_blocks) do
    local has_dig = false
    for x = 0, 15 do
        for y = 0, 15 do
            if block.designation[x][y].dig ~= 0 then
                has_dig = true
                break
            end
        end
        if has_dig then break end
    end
    if has_dig then
        block.flags.designated = true
        table.insert(blocks_with_digs, block)
        print(string.format("Set designated=true on block at (%d,%d,%d), flag now=%s", 
            block.map_pos.x, block.map_pos.y, block.map_pos.z, tostring(block.flags.designated)))
    end
end
print("Total blocks flagged: " .. #blocks_with_digs)

-- Also check: is the channel designation at z97 on the correct tile type?
local x, y, z = 90, 100, 97
local block = dfhack.maps.getTileBlock(x, y, z)
if block then
    local lx = x % 16
    local ly = y % 16
    local tt = block.tiletype[lx][ly]
    local attrs = df.tiletype.attrs[tt]
    local shape_name = df.tiletype_shape[attrs.shape] or tostring(attrs.shape)
    local mat_name = df.tiletype_material[attrs.material] or tostring(attrs.material)
    print(string.format("\nEntrance tile (%d,%d,%d): shape=%s material=%s dig=%d",
        x, y, z, shape_name, mat_name, block.designation[lx][ly].dig))
end
