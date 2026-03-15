-- Assign labors to new migrants
local function assign(unit_id, labors)
    local unit = df.unit.find(unit_id)
    if not unit then return end
    -- Enable hauling on everyone
    unit.status.labors.HAUL_STONE = true
    unit.status.labors.HAUL_WOOD = true
    unit.status.labors.HAUL_FOOD = true
    unit.status.labors.HAUL_ITEM = true
    unit.status.labors.HAUL_BODY = true
    unit.status.labors.HAUL_REFUSE = true
    unit.status.labors.HAUL_FURNITURE = true
    for _, labor in ipairs(labors) do
        unit.status.labors[labor] = true
    end
    local name = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
    print(string.format("  Assigned labors to %s (%s)", name, unit.profession))
end

print("=== Assigning migrant labors ===")

-- Edom (2130) - Woodcutter: CUTWOOD + HERBALIST + BREWER
assign(2130, {"CUTWOOD", "HERBALIST", "BREWER"})

-- Deduk (7462) - Glassmaker: HERBALIST + BREWER + PLANT
assign(7462, {"HERBALIST", "BREWER", "PLANT"})

-- Lokum (15068) - Miner: MINE + MASON
assign(15068, {"MINE", "MASON"})

-- Litast (18995) - Engraver: DETAIL + MASON + HERBALIST
assign(18995, {"DETAIL", "MASON", "HERBALIST"})

-- Dastot (18996) - Weaponsmith: FORGE_WEAPON + SMELT + HERBALIST
assign(18996, {"FORGE_WEAPON", "SMELT", "HERBALIST"})

-- Mistom (18997) - Armorer: FORGE_ARMOR + SMELT + HERBALIST
assign(18997, {"FORGE_ARMOR", "SMELT", "HERBALIST"})

-- Os (5787) - Peasant: HERBALIST + BREWER + CARPENTER + PLANT
assign(5787, {"HERBALIST", "BREWER", "CARPENTER", "PLANT"})

-- Rakust (3419) - Peasant: HERBALIST + BREWER + MASON + PLANT
assign(3419, {"HERBALIST", "BREWER", "MASON", "PLANT"})

print("Done! All migrants assigned.")
