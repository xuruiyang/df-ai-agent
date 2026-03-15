-- Debug: what are the 141 jobs?
local counts = {}
local link = df.global.world.jobs.list.next
while link do
    local jt = df.job_type[link.item.job_type]
    counts[jt] = (counts[jt] or 0) + 1
    link = link.next
end

print("Job type counts:")
for jt, count in pairs(counts) do
    print(string.format("  %s: %d", jt, count))
end

-- Check if dwarves can path to workshops
print("\nPathability check:")
local carp = df.building.find(8)
if carp then
    local cx, cy, cz = carp.x1+1, carp.y1+1, carp.z
    print(string.format("Carpenter at %d,%d,%d", cx, cy, cz))

    -- Check if any citizen can reach the workshop
    for _, unit in ipairs(df.global.world.units.active) do
        if dfhack.units.isCitizen(unit) and not unit.flags1.dead then
            local ux, uy, uz = unit.pos.x, unit.pos.y, unit.pos.z
            -- Simple z-level check
            if uz == cz then
                local name = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
                print(string.format("  %s at %d,%d,%d (same z)", name, ux, uy, uz))
            end
        end
    end
end

-- Check if there are any items available
print("\nAvailable items for carpentry (logs):")
local log_count = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.WOOD and not item.flags.forbid and not item.flags.dump and not item.flags.in_building then
        log_count = log_count + 1
        if log_count <= 5 then
            print(string.format("  Log at %d,%d,%d in_job=%s", item.pos.x, item.pos.y, item.pos.z, tostring(item.flags.in_job)))
        end
    end
end
print("Total available logs: " .. log_count)

-- Check boulders for masonry
local boulder_count = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BOULDER and not item.flags.forbid and not item.flags.in_building then
        boulder_count = boulder_count + 1
    end
end
print("Total available boulders: " .. boulder_count)

-- Check brewable plants
local plant_count = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.PLANT and not item.flags.forbid then
        plant_count = plant_count + 1
    end
end
print("Total plants (brewable): " .. plant_count)
