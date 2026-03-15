-- Cancel all pending dig designations and check items
local count = 0
local link = df.global.world.jobs.list.next
local to_remove = {}
while link do
    if link.item.job_type == df.job_type.Dig
       or link.item.job_type == df.job_type.CarveUpwardStaircase
       or link.item.job_type == df.job_type.CarveDownwardStaircase
       or link.item.job_type == df.job_type.CarveUpDownStaircase then
        table.insert(to_remove, link.item)
    end
    link = link.next
end

for _, job in ipairs(to_remove) do
    dfhack.job.removeJob(job)
    count = count + 1
end
print("Cancelled " .. count .. " dig jobs")

-- Check remaining jobs
local remaining = 0
link = df.global.world.jobs.list.next
while link do
    remaining = remaining + 1
    link = link.next
end
print("Remaining jobs: " .. remaining)

-- Now check items
local log_count = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.WOOD and not item.flags.forbid and not item.flags.in_building then
        log_count = log_count + 1
        if log_count <= 3 then
            print(string.format("  Log at %d,%d,%d in_job=%s", item.pos.x, item.pos.y, item.pos.z, tostring(item.flags.in_job)))
        end
    end
end
print("Available logs: " .. log_count)

local boulder_count = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BOULDER and not item.flags.forbid and not item.flags.in_building then
        boulder_count = boulder_count + 1
    end
end
print("Available boulders: " .. boulder_count)

local plant_count = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.PLANT and not item.flags.forbid then
        plant_count = plant_count + 1
        if plant_count <= 3 then
            print(string.format("  Plant: %s at %d,%d,%d", dfhack.items.getDescription(item, 0), item.pos.x, item.pos.y, item.pos.z))
        end
    end
end
print("Available plants: " .. plant_count)

-- Check for barrels (needed for brewing)
local barrel_count = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BARREL and not item.flags.forbid and not item.flags.in_building then
        barrel_count = barrel_count + 1
    end
end
print("Available barrels: " .. barrel_count)

-- Check for empty barrels specifically
local empty_barrel = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BARREL and #item.general_refs == 0 and not item.flags.in_job then
        empty_barrel = empty_barrel + 1
    end
end
print("Empty barrels: " .. empty_barrel)
