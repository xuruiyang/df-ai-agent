-- Check for wounded dwarves and Give Food jobs
-- Use dfhack.units functions instead of direct flag access

for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) then
        local name = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
        local issues = {}

        if dfhack.units.isDead(unit) then table.insert(issues, "DEAD") end

        -- Check wounds
        if unit.body.wound_next_id > 0 then
            table.insert(issues, "WOUNDED")
        end

        -- Check current job
        if unit.job.current_job then
            local jt = df.job_type[unit.job.current_job.job_type]
            table.insert(issues, "job=" .. jt)
        else
            table.insert(issues, "job=none")
        end

        -- Check counters
        if unit.counters.unconscious > 0 then table.insert(issues, "UNCONSCIOUS") end

        if unit.body.wound_next_id > 0 or dfhack.units.isDead(unit) then
            print(string.format("  %s: %s", name, table.concat(issues, ", ")))
        end
    end
end

-- Count Give Food/Water jobs
local give_food = 0
local give_water = 0
local link = df.global.world.jobs.list.next
while link do
    local jt = link.item.job_type
    if jt == df.job_type.GiveFood or jt == df.job_type.GiveFood2 then
        give_food = give_food + 1
    elseif jt == df.job_type.GiveWater or jt == df.job_type.GiveWater2 then
        give_water = give_water + 1
    end
    link = link.next
end
print(string.format("\nPending GiveFood jobs: %d, GiveWater jobs: %d", give_food, give_water))

-- If there are many give food/water jobs, cancel them to free up labor
if give_food + give_water > 5 then
    print("Too many feed/water jobs! Canceling to free labor...")
    local canceled = 0
    local to_remove = {}
    link = df.global.world.jobs.list.next
    while link do
        local jt = link.item.job_type
        if jt == df.job_type.GiveFood or jt == df.job_type.GiveFood2
           or jt == df.job_type.GiveWater or jt == df.job_type.GiveWater2 then
            table.insert(to_remove, link.item)
        end
        link = link.next
    end
    for _, job in ipairs(to_remove) do
        dfhack.job.removeJob(job)
        canceled = canceled + 1
    end
    print("Canceled " .. canceled .. " feed/water jobs")
end

-- Disable FEED_WATER_CIVILIANS and RECOVER_WOUNDED to stop the spam
print("\nDisabling feed/recover labors to prevent spam...")
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) then
        unit.status.labors[df.unit_labor.FEED_WATER_CIVILIANS] = false
        unit.status.labors[df.unit_labor.RECOVER_WOUNDED] = false
    end
end
print("Feed/recover labors disabled on all citizens")
