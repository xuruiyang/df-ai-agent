print("Checking axes and picks:")
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) then
        for _, inv in ipairs(unit.inventory) do
            local name = dfhack.items.getDescription(inv.item, 0)
            if name:lower():find("axe") or name:lower():find("pick") then
                local uname = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
                print(string.format("  %s has %s (mode=%d)", uname, name, inv.mode))
            end
        end
    end
end

-- Check for axes on the ground
print("\nAxes on ground:")
for _, item in ipairs(df.global.world.items.all) do
    local name = dfhack.items.getDescription(item, 0)
    if name:lower():find("axe") and item.pos.x > 0 and not item.flags.in_inventory then
        print(string.format("  %s at (%d,%d,%d)", name, item.pos.x, item.pos.y, item.pos.z))
    end
end
