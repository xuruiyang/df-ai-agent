local cleared = 0
for _, block in ipairs(df.global.world.map.map_blocks) do
    for x = 0, 15 do
        for y = 0, 15 do
            if block.designation[x][y].dig ~= 0 then
                local tt = block.tiletype[x][y]
                local mat = df.tiletype_material[df.tiletype.attrs[tt].material] or "?"
                if mat == "TREE" or mat == "PLANT" then
                    block.designation[x][y].dig = 0
                    cleared = cleared + 1
                end
            end
        end
    end
end
print("Cleared " .. cleared .. " tree/plant dig designations")

-- Also clear any remaining dig designations that are on already-dug tiles
local cleared2 = 0
for _, block in ipairs(df.global.world.map.map_blocks) do
    for x = 0, 15 do
        for y = 0, 15 do
            if block.designation[x][y].dig ~= 0 then
                local tt = block.tiletype[x][y]
                local shape = df.tiletype_shape[df.tiletype.attrs[tt].shape] or "?"
                -- If it's already floor/stair, clear dig designation
                if shape == "FLOOR" or shape:find("STAIR") then
                    block.designation[x][y].dig = 0
                    cleared2 = cleared2 + 1
                end
            end
        end
    end
end
print("Cleared " .. cleared2 .. " designations on already-dug tiles")
