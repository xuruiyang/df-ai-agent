-- Comprehensive fortress health check
print("======= FORTRESS HEALTH =======")

-- Population
local adults = 0
local children = 0
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit) then
        if dfhack.units.isChild(unit) then children = children + 1
        else adults = adults + 1 end
    end
end
print(string.format("Population: %d adults, %d children", adults, children))

-- Food & Drink
local food = 0
local drinks = 0
for _, item in ipairs(df.global.world.items.all) do
    if not item.flags.forbid and not item.flags.dump and not item.flags.rotten then
        local tp = item:getType()
        if tp == df.item_type.DRINK then drinks = drinks + item.stack_size end
        if tp == df.item_type.MEAT or tp == df.item_type.FISH or
           tp == df.item_type.PLANT or tp == df.item_type.CHEESE or
           tp == df.item_type.FOOD then food = food + 1 end
    end
end
print(string.format("Drinks: %d, Food items: %d", drinks, food))

-- Barrels
local barrels = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BARREL and not item.flags.in_building and not item.flags.forbid and not item.flags.in_job then
        barrels = barrels + 1
    end
end
print(string.format("Free barrels: %d", barrels))

-- Trade goods
local trade_goods = 0
for _, item in ipairs(df.global.world.items.all) do
    if not item.flags.in_building and not item.flags.forbid then
        local tp = item:getType()
        if tp == df.item_type.AMULET or tp == df.item_type.BRACELET or 
           tp == df.item_type.CROWN or tp == df.item_type.RING or
           tp == df.item_type.FIGURINE or tp == df.item_type.EARRING or
           tp == df.item_type.SCEPTER then
            trade_goods = trade_goods + 1
        end
    end
end
print(string.format("Trade goods (jewelry/crafts): %d", trade_goods))

-- Beds/Bedrooms
local beds_placed = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BED and item.flags.in_building then beds_placed = beds_placed + 1 end
end
print(string.format("Beds placed: %d (need %d)", beds_placed, adults + children))

-- Military
print(string.format("\nMilitary squads: %d", #df.global.ui.main.fortress_entity.squads))

-- Happiness check
local happy = 0
local unhappy = 0
local stressed = 0
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit) and not dfhack.units.isChild(unit) then
        local stress = unit.status.current_soul.personality.stress_level
        if stress < 100000 then happy = happy + 1
        elseif stress < 250000 then unhappy = unhappy + 1
        else stressed = stressed + 1 end
    end
end
print(string.format("Morale: %d happy, %d unhappy, %d stressed", happy, unhappy, stressed))

-- Workshops
local workshops_built = 0
local workshops_pending = 0
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) or df.building_furnacest:is_instance(bld) then
        if bld.flags.exists then workshops_built = workshops_built + 1
        else workshops_pending = workshops_pending + 1 end
    end
end
print(string.format("\nWorkshops: %d built, %d pending", workshops_built, workshops_pending))

-- Farms
local farms = 0
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.FarmPlot and bld.flags.exists then farms = farms + 1 end
end
print(string.format("Active farms: %d", farms))

print("\n======= END =======")
