-- Find tree trunks (lowest WALL+TREE tile for each tree) and designate
-- Only at z97 (surface level) to avoid inaccessible tiles
local count = 0
local max_trees = 15  -- Don't chop everything, just enough

for _, plant in ipairs(df.global.world.plants.all) do
    if count >= max_trees then break end
    if plant.tree_info then
        local x, y, z = plant.pos.x, plant.pos.y, plant.pos.z
        -- Only near fortress, surface level range
        if z >= 96 and z <= 98 and math.abs(x - 94) < 20 and math.abs(y - 100) < 20 then
            -- Verify it's a tree trunk tile
            local block = dfhack.maps.getTileBlock(x, y, z)
            if block then
                local lx, ly = x%16, y%16
                local tt = block.tiletype[lx][ly]
                local attrs = df.tiletype.attrs[tt]
                local shape = df.tiletype_shape[attrs.shape] or "?"
                local mat = df.tiletype_material[attrs.material] or "?"
                if mat == "TREE" and shape == "WALL" and block.designation[lx][ly].dig == 0 then
                    block.designation[lx][ly].dig = df.tile_dig_designation.Default
                    block.flags.designated = true
                    count = count + 1
                end
            end
        end
    end
end
print("Designated " .. count .. " trees for chopping")
