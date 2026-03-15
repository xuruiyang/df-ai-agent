-- Check materials around our exploratory shaft at x=94, y=100
print("=== Exploratory Shaft Materials ===")
for z = 96, 85, -1 do
    local materials = {}
    -- Check tiles around the shaft
    for dx = -3, 3 do
        for dy = -3, 3 do
            local x = 94 + dx
            local y = 100 + dy
            local block = dfhack.maps.getTileBlock(x, y, z)
            if block then
                local lx = x % 16
                local ly = y % 16
                local tiletype = block.tiletype[lx][ly]
                local attrs = df.tiletype.attrs[tiletype]
                local mat = df.tiletype_material[attrs.material]
                if mat == "MINERAL" or mat == "STONE" or mat == "SOIL" then
                    -- Get the actual inorganic material
                    local mat_idx = cycleOccupancy
                end
            end
        end
    end
end
