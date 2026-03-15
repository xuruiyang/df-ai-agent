-- Check what fields exist on block.flags
local block = dfhack.maps.getTileBlock(90, 100, 97)
if block then
    print("Block flags fields:")
    for k, v in pairs(block.flags) do
        print(string.format("  %s = %s", tostring(k), tostring(v)))
    end
end

-- Also try checking jobs via linked list
print("\nJob list check:")
local job = df.global.world.jobs.list.next
local count = 0
while job do
    if count < 5 then
        local j = job.item
        if j then
            print(string.format("  Job: %s", tostring(df.job_type[j.job_type])))
        end
    end
    count = count + 1
    job = job.next
end
print("Total linked list jobs: " .. count)
