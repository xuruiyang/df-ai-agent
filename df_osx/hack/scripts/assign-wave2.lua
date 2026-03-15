local function assign(uid, labors)
    local unit = df.unit.find(uid)
    if not unit then return end
    unit.status.labors.HAUL_STONE = true
    unit.status.labors.HAUL_WOOD = true
    unit.status.labors.HAUL_FOOD = true
    unit.status.labors.HAUL_ITEM = true
    unit.status.labors.HAUL_BODY = true
    unit.status.labors.HAUL_REFUSE = true
    unit.status.labors.HAUL_FURNITURE = true
    for _, l in ipairs(labors) do
        local ok = pcall(function() unit.status.labors[l] = true end)
        if not ok then print("  BAD LABOR: " .. l) end
    end
    print("  Assigned: " .. dfhack.TranslateName(dfhack.units.getVisibleName(unit)))
end

-- Only assign the ones that failed (Urdim and Olin already done)
assign(19104, {"CLOTHESMAKER", "HERBALIST", "BREWER"})       -- Nil
assign(19107, {"METAL_CRAFT", "SMELT", "HERBALIST"})         -- Mafol
assign(19108, {"CUT_GEM", "HERBALIST"})                      -- Cilob
assign(14590, {"HERBALIST", "BREWER", "PLANT", "CARPENTER"}) -- Minkot
assign(19109, {"WOOD_CRAFT", "HERBALIST", "CARPENTER"})      -- Vucar
assign(19110, {"METAL_CRAFT", "SMELT", "HERBALIST"})         -- Iden
print("Wave 2 assignments complete!")
