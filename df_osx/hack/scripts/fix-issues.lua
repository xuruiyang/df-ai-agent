-- 1. Clear all remaining dig designations (they were already dug by dig-now)
local cleared = 0
for _, block in ipairs(df.global.world.map.map_blocks) do
    for x = 0, 15 do
        for y = 0, 15 do
            if block.designation[x][y].dig ~= 0 then
                block.designation[x][y].dig = 0
                cleared = cleared + 1
            end
        end
    end
end
print("Cleared " .. cleared .. " leftover dig designations")

-- 2. Check manager orders
print("\nManager orders:")
for i, order in ipairs(df.global.world.manager_orders) do
    local jt = df.job_type[order.job_type] or "?"
    local reaction = order.reaction_name or ""
    print(string.format("  Order %d: %s reaction='%s' remaining=%d/%d", 
        order.id, jt, reaction, order.amount_left, order.amount_total))
end

-- 3. Check all workshop jobs
print("\nWorkshop jobs:")
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.Workshop and bld.flags.exists then
        local ws = df.workshop_type[bld:getSubtype()] or "?"
        print(string.format("  %s (id=%d): %d jobs", ws, bld.id, #bld.jobs))
        for _, job in ipairs(bld.jobs) do
            print(string.format("    Job: %s", tostring(df.job_type[job.job_type])))
        end
    end
end

-- 4. List all known reactions
print("\nAvailable reactions (brewing):")
for _, reaction in ipairs(df.global.world.raws.reactions.reactions) do
    if reaction.name:lower():find("brew") or reaction.code:lower():find("brew") then
        print(string.format("  code='%s' name='%s'", reaction.code, reaction.name))
    end
end
