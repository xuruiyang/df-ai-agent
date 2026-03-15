print("Picks:")
for _, item in ipairs(df.global.world.items.all) do
    local name = dfhack.items.getDescription(item, 0)
    if name:lower():find("pick") then
        local in_use = item.flags.in_building or item.flags.in_job
        print(string.format("  %s at (%d,%d,%d) id=%d in_use=%s in_inv=%s", 
            name, item.pos.x, item.pos.y, item.pos.z, item.id,
            tostring(in_use), tostring(item.flags.in_inventory)))
    end
end

-- Check Monom's inventory
local monom = df.unit.find(7319)
if monom then
    print("\nMonom's inventory:")
    local has_pick = false
    for _, inv in ipairs(monom.inventory) do
        local name = dfhack.items.getDescription(inv.item, 0)
        print(string.format("  %s (mode=%d)", name, inv.mode))
        if name:lower():find("pick") then has_pick = true end
    end
    if not has_pick then print("  NO PICK!") end
end
