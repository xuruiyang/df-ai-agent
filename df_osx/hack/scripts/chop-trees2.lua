-- Clear previous bad designations at underground levels
local cleared = 0
for _, block in ipairs(df.global.world.map.map_blocks) do
    if block.map_pos.z < 90 then  -- underground
        for x = 0, 15 do
            for y = 0, 15 do
                if block.designation[x][y].dig ~= 0 then
                    block.designation[x][y].dig = 0
                    cleared = cleared + 1
                end
            end
        end
    end
end
print("Cleared " .. cleared .. " underground designations")

-- Find surface trees (z >= 95) near fortress
local count = 0
for _, plant in ipairs(df.global.world.plants.all) do
    if plant.tree_info and plant.pos.z >= 95 then
        local x, y, z = plant.pos.x, plant.pos.y, plant.pos.z
        if math.abs(x - 89) < 20 and math.abs(y - 100) < 20 then
            local block = dfhack.maps.getTileBlock(x, y, z)
            if block then
                local lx = x % 16
                local ly = y % 16
                if block.designation[lx][ly].dig == 0 then
                    block.designation[lx][ly].dig = df.tile_dig_designation.Default
                    block.flags.designated = true
                    count = count + 1
                    if count <= 10 then
                        print(string.format("Chop tree at (%d,%d,%d)", x, y, z))
                    end
                end
            end
        end
    end
end
print("Surface trees designated: " .. count)
