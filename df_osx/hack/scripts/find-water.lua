-- Find the nearest water to our fortress (wagon at 101,102,z178)
local wx, wy, wz = 101, 102, 178

-- Scan for water tiles starting from the highest z-level
local best_dist = 999999
local best_x, best_y, best_z = 0, 0, 0
local water_count = 0

-- Check z-levels from 178 down to 140
for z = 178, 140, -1 do
    for x = 0, 191 do
        for y = 0, 191 do
            local block = dfhack.maps.getTileBlock(x, y, z)
            if block then
                local lx = x % 16
                local ly = y % 16
                local des = block.designation[lx][ly]
                if des.flow_size > 0 and not des.hidden then
                    water_count = water_count + 1
                    local dist = math.abs(x - wx) + math.abs(y - wy) + math.abs(z - wz) * 3
                    if dist < best_dist then
                        best_dist = dist
                        best_x, best_y, best_z = x, y, z
                    end
                end
            end
        end
    end
    if water_count > 0 then
        break  -- Found water on this z-level
    end
end

if water_count > 0 then
    print(string.format("Nearest water: %d,%d,%d (dist=%d, %d tiles found on that z)",
        best_x, best_y, best_z, best_dist, water_count))
    print(string.format("Z-difference from fortress: %d levels down", wz - best_z))
else
    print("No visible water found near fortress z-levels")
    -- Check lower
    for z = 139, 100, -1 do
        local block = dfhack.maps.getTileBlock(wx, wy, z)
        if block then
            local lx = wx % 16
            local ly = wy % 16
            local des = block.designation[lx][ly]
            if des.flow_size > 0 then
                print(string.format("Water found at z=%d below wagon", z))
                break
            end
        end
    end
end

-- Also check for surface water (brooks, ponds, murky pools)
print("\nChecking surface z-levels 147-150 for water...")
local surface_water = 0
for z = 147, 150 do
    for x = wx - 50, wx + 50 do
        for y = wy - 50, wy + 50 do
            local block = dfhack.maps.getTileBlock(x, y, z)
            if block then
                local lx = x % 16
                local ly = y % 16
                local des = block.designation[lx][ly]
                if des.flow_size > 0 then
                    surface_water = surface_water + 1
                    if surface_water <= 5 then
                        print(string.format("  Surface water at %d,%d,%d flow=%d", x, y, z, des.flow_size))
                    end
                end
            end
        end
    end
end
print("Surface water tiles: " .. surface_water)
