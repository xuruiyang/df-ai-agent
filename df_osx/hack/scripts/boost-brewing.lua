-- Enable food hauling on all dwarves and queue lots of brew jobs
local race_id = df.global.ui.race_id

-- Enable HAUL_FOOD on all citizens
local enabled = 0
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) then
        unit.status.labors.HAUL_FOOD = true
        unit.status.labors.HAUL_ITEM = true
        enabled = enabled + 1
    end
end
print(string.format("Enabled food/item hauling on %d dwarves", enabled))

-- Check how many brew jobs are currently queued
local brew_jobs = 0
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) then
        for _, job in ipairs(bld.jobs) do
            if job.reaction_name == "BREW_DRINK_FROM_PLANT" then
                brew_jobs = brew_jobs + 1
            end
        end
    end
end
print(string.format("Current brew jobs queued: %d", brew_jobs))

-- Count empty barrels
local empty_barrels = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BARREL
       and not item.flags.in_building
       and not item.flags.forbid
       and not item.flags.in_job then
        -- Check if barrel is empty (no contained items)
        local contained = #item.general_refs
        local has_contents = false
        for _, ref in ipairs(item.general_refs) do
            if df.general_ref_contains_itemst:is_instance(ref) then
                has_contents = true
                break
            end
        end
        if not has_contents then
            empty_barrels = empty_barrels + 1
        end
    end
end
print(string.format("Empty barrels available: %d", empty_barrels))
