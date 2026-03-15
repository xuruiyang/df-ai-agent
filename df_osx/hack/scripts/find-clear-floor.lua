-- Find clear floor tiles near the wagon for digging entrance
print("Scanning for clear FLOOR tiles near wagon:")
for x = 85, 100 do
    for y = 95, 105 do
        local block = dfhack.maps.getTileBlock(x, y, 97)
        if block then
            local lx = x % 16
            local ly = y % 16
            local tt = block.tiletype[lx][ly]
            local attrs = df.tiletype.attrs[tt]
            local shape = df.tiletype_shape[attrs.shape] or "?"
            local mat = df.tiletype_material[attrs.material] or "?"
            if shape == "FLOOR" and (mat == "SOIL" or mat == "GRASS_LIGHT" or mat == "GRASS_DARK" or mat == "STONE" or mat == "MINERAL") then
                -- Check it's not under the wagon (89-91, 100-102)
                if not (x >= 89 and x <= 91 and y >= 100 and y <= 102) then
                    print(string.format("  (%d,%d,97) shape=%s mat=%s", x, y, shape, mat))
                end
            end
        end
    end
end
