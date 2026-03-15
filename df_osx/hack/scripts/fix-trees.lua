-- Clear dig designations that were incorrectly placed on tree tiles
local cleared = 0
for _, block in ipairs(df.global.world.map.map_blocks) do
    for x = 0, 15 do
        for y = 0, 15 do
            if block.designation[x][y].dig ~= 0 then
                local tt = block.tiletype[x][y]
                local mat = df.tiletype_material[df.tiletype.attrs[tt].material] or "?"
                if mat == "TREE" then
                    block.designation[x][y].dig = 0
                    cleared = cleared + 1
                end
            end
        end
    end
end
print("Cleared " .. cleared .. " incorrect tree dig designations")
