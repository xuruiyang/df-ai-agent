-- Handle wave 4 migrants: enable hauling, assign labors
local known_ids = {}
-- Build a set of known citizens from before this wave (anyone we've seen before)
-- Since we can't easily track, just find units without hauling enabled (new arrivals)
local new_count = 0
local hauling_labors = {
    df.unit_labor.HAUL_STONE, df.unit_labor.HAUL_WOOD,
    df.unit_labor.HAUL_BODY, df.unit_labor.HAUL_FOOD,
    df.unit_labor.HAUL_REFUSE, df.unit_labor.HAUL_ITEM,
    df.unit_labor.HAUL_FURNITURE, df.unit_labor.HAUL_ANIMALS,
    df.unit_labor.CLEAN,
}

for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit) and not dfhack.units.isChild(unit) and unit.mood < 0 then
        -- Check if they have hauling enabled (old dwarves have it)
        if not unit.status.labors[df.unit_labor.HAUL_STONE] then
            local name = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
            local prof = df.profession[unit.profession]
            print(string.format("  New: %s id=%d prof=%s", name, unit.id, prof))
            -- Enable hauling
            for _, labor in ipairs(hauling_labors) do
                unit.status.labors[labor] = true
            end
            -- Assign primary labor based on profession
            if prof == "MINER" then unit.status.labors[df.unit_labor.MINE] = true
            elseif prof == "MASON" then unit.status.labors[df.unit_labor.MASON] = true
            elseif prof == "CARPENTER" then unit.status.labors[df.unit_labor.CARPENTER] = true
            elseif prof == "FARMER" or prof == "PLANTER" then
                unit.status.labors[df.unit_labor.PLANT] = true
                unit.status.labors[df.unit_labor.HERBALIST] = true
            elseif prof == "BREWER" then unit.status.labors[df.unit_labor.BREWER] = true
            elseif prof == "COOK" then unit.status.labors[df.unit_labor.COOK] = true
            else
                -- Generic: enable mining or crafting
                unit.status.labors[df.unit_labor.MINE] = true
                unit.status.labors[df.unit_labor.STONE_CRAFT] = true
            end
            new_count = new_count + 1
        end
    end
end
print(string.format("Processed %d new migrants", new_count))
