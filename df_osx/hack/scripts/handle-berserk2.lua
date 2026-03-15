-- Check wounds and military status
print("=== WOUNDED CITIZENS ===")
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit) then
        if #unit.body.wounds > 0 then
            local name = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
            print(string.format("  %s has %d wounds", name, #unit.body.wounds))
        end
    end
end

-- Military squads
print("\n=== MILITARY ===")
local entity = df.global.ui.main.fortress_entity
print(string.format("  Total squads: %d", #entity.squads))

-- Find best fighters (by military-related skills)
print("\n=== POTENTIAL SOLDIERS ===")
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit) and unit.mood < 0 then
        local name = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
        -- Check for weapon skill
        local best_combat = 0
        for _, skill in ipairs(unit.status.current_soul.skills) do
            local sid = skill.id
            -- Combat skills: SWORD, AXE, MACE, etc
            if sid == df.job_skill.SWORD or sid == df.job_skill.AXE or
               sid == df.job_skill.MACE or sid == df.job_skill.HAMMER or
               sid == df.job_skill.SPEAR or sid == df.job_skill.CROSSBOW or
               sid == df.job_skill.WRESTLING or sid == df.job_skill.ARMOR or
               sid == df.job_skill.SHIELD or sid == df.job_skill.DODGING or
               sid == df.job_skill.MELEE_COMBAT then
                if skill.rating > best_combat then best_combat = skill.rating end
            end
        end
        if best_combat > 0 then
            print(string.format("  %s id=%d combat_skill=%d", name, unit.id, best_combat))
        end
    end
end

-- Check weapons availability
print("\n=== WEAPONS ===")
local weapons = 0
for _, item in ipairs(df.global.world.items.all) do
    if not item.flags.in_building and not item.flags.forbid then
        local tp = item:getType()
        if tp == df.item_type.WEAPON then
            weapons = weapons + 1
        end
    end
end
print(string.format("  Available weapons: %d", weapons))

-- Check Urdim's exact distance from fortress
print("\n=== URDIM LOCATION ===")
local urdim = df.unit.find(19100)
if urdim then
    print(string.format("  Urdim at (%d,%d,z%d) — fortress entrance at ~(94,100,z97)", urdim.pos.x, urdim.pos.y, urdim.pos.z))
    print(string.format("  Distance: ~%d tiles", math.abs(urdim.pos.x-94) + math.abs(urdim.pos.y-100)))
end
