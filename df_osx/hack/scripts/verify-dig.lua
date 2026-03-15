-- Verify the entrance designations are still set
local x, y, z = 90, 100, 97
local block = dfhack.maps.getTileBlock(x, y, z)
if block then
    local lx = x % 16
    local ly = y % 16
    print(string.format("(%d,%d,%d): dig=%d, designated_flag=%s", x, y, z, 
        block.designation[lx][ly].dig, tostring(block.flags.designated)))
    
    local lx2 = 91 % 16
    print(string.format("(91,%d,%d): dig=%d", y, z, block.designation[lx2][ly].dig))
end

-- Check jobs via linked list
local job = df.global.world.jobs.list.next
local count = 0
while job do
    local j = job.item
    if j and count < 10 then
        print(string.format("Job: %s at (%d,%d,%d)", tostring(df.job_type[j.job_type]), j.pos.x, j.pos.y, j.pos.z))
    end
    count = count + 1
    job = job.next
end
print("Total jobs: " .. count)

-- Check Sigun's equipment again
local unit = df.unit.find(18792)
if unit then
    print(string.format("\nSigun at (%d,%d,%d), mining labor=%s", 
        unit.pos.x, unit.pos.y, unit.pos.z,
        tostring(unit.status.labors[df.unit_labor.MINE])))
    for _, inv in ipairs(unit.inventory) do
        local name = dfhack.items.getDescription(inv.item, 0)
        if name:lower():find("pick") then
            print("  Has pick: " .. name .. " mode=" .. tostring(inv.mode))
        end
    end
end
