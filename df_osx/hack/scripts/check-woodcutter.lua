-- Check Reg's equipment for an axe
local reg = df.unit.find(18797)
if reg then
    print("Reg's inventory:")
    for _, inv in ipairs(reg.inventory) do
        local name = dfhack.items.getDescription(inv.item, 0)
        print(string.format("  %s (mode=%d)", name, inv.mode))
    end
    print("Current job: " .. (reg.job.current_job and tostring(df.job_type[reg.job.current_job.job_type]) or "none"))
    print("CUTWOOD labor: " .. tostring(reg.status.labors[df.unit_labor.CUTWOOD]))
end

-- Check Asmel (woodworker) for axe too
local asmel = df.unit.find(18795)
if asmel then
    print("\nAsmel's inventory:")
    for _, inv in ipairs(asmel.inventory) do
        local name = dfhack.items.getDescription(inv.item, 0)
        print(string.format("  %s (mode=%d)", name, inv.mode))
    end
    print("CUTWOOD labor: " .. tostring(asmel.status.labors[df.unit_labor.CUTWOOD]))
end

-- Where are the battle axes?
print("\nAvailable axes:")
for _, item in ipairs(df.global.world.items.all) do
    local name = dfhack.items.getDescription(item, 0)
    if name:lower():find("axe") and item.pos.x > 0 then
        print(string.format("  %s at (%d,%d,%d) id=%d", name, item.pos.x, item.pos.y, item.pos.z, item.id))
    end
end
