-- Create stockpiles using abstract construction
local food_pile = dfhack.buildings.constructBuilding{
    type = df.building_type.Stockpile,
    abstract = true,
    pos = xyz2pos(97, 100, 178),
    width = 5,
    height = 5,
}
if food_pile then
    food_pile.settings.flags.food = true
    food_pile.settings.flags.animals = false
    food_pile.settings.flags.furniture = false
    food_pile.settings.flags.corpses = false
    food_pile.settings.flags.refuse = false
    food_pile.settings.flags.stone = false
    food_pile.settings.flags.ammo = false
    food_pile.settings.flags.coins = false
    food_pile.settings.flags.bars_blocks = false
    food_pile.settings.flags.gems = false
    food_pile.settings.flags.finished_goods = false
    food_pile.settings.flags.leather = false
    food_pile.settings.flags.cloth = false
    food_pile.settings.flags.wood = false
    food_pile.settings.flags.weapons = false
    food_pile.settings.flags.armor = false
    food_pile.settings.flags.sheet = false
    print("Food stockpile created, ID=" .. food_pile.id)
else
    print("Failed to create food stockpile")
end

-- General stockpile on surface
local gen_pile = dfhack.buildings.constructBuilding{
    type = df.building_type.Stockpile,
    abstract = true,
    pos = xyz2pos(88, 100, 178),
    width = 5,
    height = 5,
}
if gen_pile then
    -- Leave as default (accepts everything)
    print("General stockpile created, ID=" .. gen_pile.id)
else
    print("Failed to create general stockpile")
end

print("Stockpiles done!")
