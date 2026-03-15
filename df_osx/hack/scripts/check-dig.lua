-- Check dig designations at z97 and z96 around (90,100)
print("Checking dig designations near entrance:")
for z = 96, 97 do
    for y = 98, 102 do
        for x = 88, 92 do
            local block = dfhack.maps.getTileBlock(x, y, z)
            if block then
                local lx = x % 16
                local ly = y % 16
                local desig = block.designation[lx][ly]
                local dig = desig.dig
                if dig ~= 0 then
                    local dig_name = df.tile_dig_designation[dig] or tostring(dig)
                    print(string.format("  (%d,%d,%d) dig=%s", x, y, z, dig_name))
                end
            end
        end
    end
end

-- Check if miner has a pick equipped
print("\nChecking miner equipment:")
local unit = df.unit.find(18792)
if unit then
    print("  Sigun's inventory:")
    for _, inv_item in ipairs(unit.inventory) do
        local item = inv_item.item
        local name = dfhack.items.getDescription(item, 0)
        print(string.format("    %s (mode=%d)", name, inv_item.mode))
    end
    if unit.job.current_job then
        print("  Current job type: " .. tostring(df.job_type[unit.job.current_job.job_type]))
    else
        print("  No current job")
    end
end
