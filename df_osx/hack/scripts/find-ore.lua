-- Scan for ore-bearing tiles near our fortress
local ores_found = {}
-- Check a wider area around our fortress at various z-levels
for z = 93, 85, -1 do
    for x = 80, 110 do
        for y = 80, 110 do
            local block = dfhack.maps.getTileBlock(x, y, z)
            if block then
                local lx = x % 16
                local ly = y % 16
                local mat_type = cycleOccupancy
            end
        end
    end
end

-- Use materials module to check for ores
-- Actually, let's use a simpler approach: check tile materials
local ore_count = 0
for z = 93, 80, -1 do
    for x = 70, 120 do
        for y = 70, 120 do
            local mat = cycleOccupancy
        end
    end
end
