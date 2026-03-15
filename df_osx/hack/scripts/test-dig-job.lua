-- Let's check if there are any pending dig jobs
print("Pending dig designations:")
local count = 0
for _, block in ipairs(df.global.world.map.map_blocks) do
    for x = 0, 15 do
        for y = 0, 15 do
            local dig = block.designation[x][y].dig
            if dig ~= 0 then
                local wx = block.map_pos.x + x
                local wy = block.map_pos.y + y
                local wz = block.map_pos.z
                if count < 5 then
                    local dig_name = df.tile_dig_designation[dig] or tostring(dig)
                    print(string.format("  (%d,%d,%d) dig=%s", wx, wy, wz, dig_name))
                end
                count = count + 1
            end
        end
    end
end
print("Total designations: " .. count)

-- Check if there are any mining jobs in the job list
print("\nAll active jobs:")
local job_count = 0
for _, job in ipairs(df.global.world.jobs.list) do
    if job_count < 10 then
        print(string.format("  Job: %s at (%d,%d,%d)", tostring(df.job_type[job.job_type]), job.pos.x, job.pos.y, job.pos.z))
    end
    job_count = job_count + 1
end
print("Total jobs: " .. job_count)
