-- Handle berserk Urdim - check location and options
print("=== BERSERK DWARF ===")
for _, unit in ipairs(df.global.world.units.active) do
    local name = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
    if name:find("Urdim") then
        print(string.format("  %s id=%d pos=(%d,%d,z%d)", name, unit.id, unit.pos.x, unit.pos.y, unit.pos.z))
        print(string.format("  mood=%d alive=%s", unit.mood, tostring(dfhack.units.isAlive(unit))))
        print(string.format("  berserk=%s crazed=%s", tostring(unit.flags1.crazed), tostring(unit.mood == 7)))
    end
end

-- Check if any dwarves are wounded
print("\n=== WOUNDED CITIZENS ===")
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit) then
        local dominated = false
        for _, wound in ipairs(unit.body.wounds) do
            dominated = true
        end
        if #unit.body.wounds > 0 then
            local name = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
            print(string.format("  %s has %d wounds", name, #unit.body.wounds))
        end
    end
end

-- Create military squad to deal with berserk dwarf
-- First, check if we have any military
print("\n=== MILITARY SQUADS ===")
local entity = df.global.ui.main.fortress_entity
print(string.format("  Squads: %d", #entity.squads))
for _, sq_id in ipairs(entity.squads) do
    local sq = df.squad.find(sq_id)
    if sq then
        local name = dfhack.TranslateName(sq.name)
        local members = 0
        for _, pos in ipairs(sq.positions) do
            if pos.occupant >= 0 then members = members + 1 end
        end
        print(string.format("  Squad '%s' id=%d members=%d", name, sq.id, members))
    end
end
