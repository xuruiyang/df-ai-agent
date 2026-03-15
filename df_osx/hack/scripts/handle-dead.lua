-- Handle corpses and prevent horror
-- 1. Find and bury/remove corpses
-- 2. Enable HAUL_BODY and HAUL_REFUSE on dwarves
-- 3. Create a refuse stockpile

-- Clean up corpses using DFHack
dfhack.run_command('cleanowned', 'scattered')

-- Create a refuse stockpile away from the main area
local refuse = dfhack.buildings.constructBuilding{
    type = df.building_type.Stockpile,
    abstract = true,
    pos = xyz2pos(85, 93, 178),
    width = 5,
    height = 5,
}
if refuse then
    refuse.settings.flags.refuse = true
    refuse.settings.flags.corpses = true
    refuse.settings.flags.food = false
    refuse.settings.flags.furniture = false
    refuse.settings.flags.stone = false
    refuse.settings.flags.ammo = false
    refuse.settings.flags.coins = false
    refuse.settings.flags.bars_blocks = false
    refuse.settings.flags.gems = false
    refuse.settings.flags.finished_goods = false
    refuse.settings.flags.leather = false
    refuse.settings.flags.cloth = false
    refuse.settings.flags.wood = false
    refuse.settings.flags.weapons = false
    refuse.settings.flags.armor = false
    refuse.settings.flags.animals = false
    refuse.settings.flags.sheet = false
    print("Refuse stockpile created, ID=" .. refuse.id)
end

-- Enable HAUL_BODY on all citizens
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) then
        unit.status.labors[df.unit_labor.HAUL_BODY] = true
        unit.status.labors[df.unit_labor.HAUL_REFUSE] = true
    end
end
print("Enabled body/refuse hauling on all citizens")

-- Count dead dwarves
local dead = 0
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) and dfhack.units.isDead(unit) then
        dead = dead + 1
        print("  Dead: " .. dfhack.TranslateName(dfhack.units.getVisibleName(unit)))
    end
end
print("Dead citizens: " .. dead)
