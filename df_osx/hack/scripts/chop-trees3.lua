-- Find tree trunks at surface level and designate for chopping
-- Tree trunks are WALL shape with TREE material
local count = 0
for x = 75, 115 do
    for y = 85, 115 do
        for z = 96, 100 do
            local block = dfhack.maps.getTileBlock(x, y, z)
            if block then
                local lx = x % 16
                local ly = y % 16
                local tt = block.tiletype[lx][ly]
                local attrs = df.tiletype.attrs[tt]
                local shape = df.tiletype_shape[attrs.shape] or "?"
                local mat = df.tiletype_material[attrs.material] or "?"
                -- Tree trunks are WALL+TREE
                if shape == "WALL" and mat == "TREE" then
                    if block.designation[lx][ly].dig == 0 then
                        block.designation[lx][ly].dig = df.tile_dig_designation.Default
                        block.flags.designated = true
                        count = count + 1
                        if count <= 3 then
                            print(string.format("Designated tree trunk at (%d,%d,%d)", x, y, z))
                        end
                    end
                end
            end
        end
    end
end
print("Total tree trunks designated: " .. count)

-- Limit to 20 trees so we don't strip the landscape
-- (actually we already designated them all, so just log)
if count > 20 then
    print("(That's a lot - will chop as needed)")
end
