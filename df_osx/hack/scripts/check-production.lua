-- Detailed workshop status
print("Workshop details:")
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.Workshop and bld.flags.exists then
        local ws = df.workshop_type[bld:getSubtype()] or "?"
        print(string.format("\n  %s (id=%d): %d jobs", ws, bld.id, #bld.jobs))
        for i, job in ipairs(bld.jobs) do
            local jt = df.job_type[job.job_type] or "?"
            local reaction = ""
            if job.reaction_name and job.reaction_name ~= "" then
                reaction = " (" .. job.reaction_name .. ")"
            end
            local status = ""
            if job.flags.suspend then status = " [SUSPENDED]" end
            print(string.format("    [%d] %s%s%s", i, jt, reaction, status))
        end
    end
end

-- Check brewable plants
print("\n\nBrewable plants check:")
local brewable = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.PLANT and item.pos.x > 0 then
        brewable = brewable + 1
    end
end
print("  Available plants: " .. brewable)

-- Check empty barrels for brewing
local empty_barrels = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BARREL and item.pos.x > 0 and 
       not item.flags.in_building and not item.flags.in_job then
        -- Check if barrel is empty (no items inside)
        local has_contents = false
        for _, ref in ipairs(item.general_refs) do
            if ref:getType() == df.general_ref_type.CONTAINS_ITEM then
                has_contents = true
                break
            end
        end
        if not has_contents then
            empty_barrels = empty_barrels + 1
        end
    end
end
print("  Empty barrels: " .. empty_barrels)

-- Check seeds
local seeds = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.SEEDS and item.pos.x > 0 then
        seeds = seeds + item.stack_size
    end
end
print("  Seeds available: " .. seeds)
