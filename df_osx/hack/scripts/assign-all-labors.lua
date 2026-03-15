-- Mass assign labors to all citizens
local function assign(unit_id, labors)
    local unit = df.unit.find(unit_id)
    if not unit then return end
    for _, labor_name in ipairs(labors) do
        local labor = df.unit_labor[labor_name]
        if labor then
            unit.status.labors[labor] = true
        end
    end
end

-- Also enable hauling for everyone
local function enable_hauling(unit_id)
    assign(unit_id, {"HAUL_STONE", "HAUL_WOOD", "HAUL_ITEM", "HAUL_FOOD", "HAUL_FURNITURE", "HAUL_TRADE", "HAUL_BODY", "HAUL_REFUSE", "CLEAN", "PULL_LEVER", "HANDLE_VEHICLES", "RECOVER_WOUNDED", "FEED_WATER_CIVILIANS"})
end

-- Nil (5085) - Primary miner
assign(5085, {"MINE"})
enable_hauling(5085)

-- Libash (5086) - Miner + Mason
assign(5086, {"MINE", "MASON", "STONE_CRAFT", "ARCHITECT"})
enable_hauling(5086)

-- Sazir (5088) - Expedition leader: Carpenter + Brewer + Build
assign(5088, {"CARPENTER", "BREWER", "PROCESS_PLANT", "BUILD_CONSTRUCTION", "ARCHITECT"})
enable_hauling(5088)

-- Sibrek (5090) - Woodcutter
assign(5090, {"CUTWOOD", "CARPENTER"})
enable_hauling(5090)

-- Reg (5359) - Farmer: farming + brewing
assign(5359, {"PLANT", "BREWER", "PROCESS_PLANT", "HERBALIST", "COOK"})
enable_hauling(5359)

-- Peasants (5357, 2274) - miners + haulers + builders
assign(5357, {"MINE", "BUILD_CONSTRUCTION", "MASON"})
enable_hauling(5357)
assign(2274, {"MINE", "BUILD_CONSTRUCTION", "CARPENTER"})
enable_hauling(2274)

-- Everyone else: hauling + general labors
local others = {5087, 5089, 5091, 5238, 5239, 5240, 5243, 5244, 2522, 5351, 5352, 5353, 5356, 5358}
for _, uid in ipairs(others) do
    enable_hauling(uid)
    assign(uid, {"BUILD_CONSTRUCTION"})
end

-- Specific skills for specialists
assign(5239, {"SMELT", "OPERATE_PUMP"})  -- Furnace Operator
assign(5351, {"SMELT", "OPERATE_PUMP"})  -- Furnace Operator
assign(5244, {"FORGE_WEAPON", "FORGE_ARMOR", "FORGE_FURNITURE", "METAL_CRAFT"})  -- Weaponsmith
assign(5352, {"CUT_GEM", "ENCRUST_GEM", "MASON"})  -- Gem Setter
assign(5353, {"BONE_CARVE", "STONE_CRAFT"})  -- Bone Carver
assign(5356, {"BOWYER", "CARPENTER", "WOOD_CRAFT"})  -- Bowyer
assign(5358, {"LEATHER", "TANNER", "CLOTHESMAKER"})  -- Leatherworker
assign(5240, {"WEAVER", "SPINNER", "CLOTHESMAKER"})  -- Weaver
assign(5243, {"DETAIL"})  -- Engraver
assign(5089, {"CLEAN_FISH", "DISSECT_FISH", "COOK"})  -- Fish Cleaner
assign(5091, {"FISH", "CLEAN_FISH"})  -- Fisher
assign(2522, {"ANIMALCARE", "ANIMALTRAIN", "PLANT"})  -- Animal Caretaker

print("All labors assigned!")

-- Count active labors per dwarf
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) then
        local count = 0
        for i = 0, df.unit_labor._last_item do
            if unit.status.labors[i] then count = count + 1 end
        end
        local name = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
        print(string.format("  %s: %d labors enabled", name, count))
    end
end
