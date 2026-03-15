-- Find tree bases: look for TREE WALL tiles at z=97 (surface level)
-- The key insight: trees in DF have trunks that start at the surface.
-- On flat terrain, tree trunks are at z97 (our surface z-level)
-- Chopping is designated on the base trunk tile

local count = 0
for x = 75, 115 do
    for y = 85, 115 do
        -- Only check z97 (surface)
        local block = dfhack.maps.getTileBlock(x, y, 97)
        if block then
            local lx = x % 16
            local ly = y % 16
            local tt = block.tiletype[lx][ly]
            local attrs = df.tiletype.attrs[tt]
            local shape = df.tiletype_shape[attrs.shape] or "?"
            local mat = df.tiletype_material[attrs.material] or "?"
            if mat == "TREE" and (shape == "WALL" or shape == "TRUNK_BRANCH") then
                block.designation[lx][ly].dig = df.tile_dig_designation.Default
                block.flags.designated = true
                count = count + 1
                if count <= 5 then
                    print(string.format("Tree trunk at (%d,%d,97) shape=%s", x, y, shape))
                end
            end
        end
    end
end
print("Designated " .. count .. " tree trunks at z97")

-- Also check z98 for trees on higher ground
local count2 = 0
for x = 75, 115 do
    for y = 85, 115 do
        local block = dfhack.maps.getTileBlock(x, y, 98)
        if block then
            local lx = x % 16
            local ly = y % 16
            local tt = block.tiletype[lx][ly]
            local attrs = df.tiletype.attrs[tt]
            local shape = df.tiletype_shape[attrs.shape] or "?"
            local mat = df.tiletype_material[attrs.material] or "?"
            -- At z98, tree trunks that START at z98 (on elevated terrain)
            -- Check if there's floor below at z97 (meaning this is not a base trunk)
            if mat == "TREE" and shape == "WALL" then
                -- Check z97 at same position
                local below = dfhack.maps.getTileBlock(x, y, 97)
                if below then
                    local btt = below.tiletype[lx][ly]
                    local battrs = df.tiletype.attrs[btt]
                    local bmat = df.tiletype_material[battrs.material] or "?"
                    -- If z97 is NOT tree, then z98 IS the base
                    if bmat ~= "TREE" then
                        block.designation[lx][ly].dig = df.tile_dig_designation.Default
                        block.flags.designated = true
                        count2 = count2 + 1
                    end
                end
            end
        end
    end
end
print("Designated " .. count2 .. " tree trunks at z98")
