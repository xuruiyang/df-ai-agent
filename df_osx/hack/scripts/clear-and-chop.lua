-- Clear ALL dig designations on TREE material tiles
local cleared = 0
for _, block in ipairs(df.global.world.map.map_blocks) do
    for x = 0, 15 do
        for y = 0, 15 do
            if block.designation[x][y].dig ~= 0 then
                local tt = block.tiletype[x][y]
                local attrs = df.tiletype.attrs[tt]
                local mat = df.tiletype_material[attrs.material] or "?"
                if mat == "TREE" then
                    block.designation[x][y].dig = 0
                    cleared = cleared + 1
                end
            end
        end
    end
end
print("Cleared " .. cleared .. " tree dig designations")

-- Now use DFHack's proper tree chopping approach
-- Trees are designated for chopping when the plant has the designation
-- Let's check if there's a way to mark plants for chopping
print("\nLooking for chop designation method...")

-- Try marking trees near fortress using the plant's flags
local chopped = 0
for _, plant in ipairs(df.global.world.plants.all) do
    if plant.tree_info then
        local x, y, z = plant.pos.x, plant.pos.y, plant.pos.z
        if z >= 95 and math.abs(x - 89) < 15 and math.abs(y - 100) < 15 then
            -- Check plant flags for chop designation
            if plant.damage_flags then
                -- not what we want
            end
            -- In DF, tree chopping is designated on the base tile using occupancy flags
            local block = dfhack.maps.getTileBlock(x, y, z)
            if block then
                -- The proper way: mark the tile with a "chop" designation
                -- In DF 0.47.05, this might be through tile_designation.smooth or something else
                chopped = chopped + 1
            end
        end
    end
end
print("Found " .. chopped .. " surface trees near fortress")

-- Just try using the DFHack built-in chop command
print("\nTrying DFHack chop commands:")
print("Trying 'autochop'...")
