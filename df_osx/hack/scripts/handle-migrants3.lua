-- Handle wave 3 migrants - identify new arrivals and assign labors
print("=== ALL CITIZENS ===")
local citizens = {}
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit) and unit.mood < 0 then
        local name = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
        local prof = df.profession[unit.profession]
        table.insert(citizens, {unit=unit, name=name, prof=prof, id=unit.id})
    end
end

print(string.format("Total citizens: %d", #citizens))

-- Known IDs from previous waves
local known = {
    [0]=true, -- initial 7 dwarves (IDs vary)
    -- Wave 1 migrants
    [2130]=true, [7462]=true, [15068]=true, [18995]=true,
    [18996]=true, [18997]=true, [5787]=true, [3419]=true,
    -- Wave 2 migrants
    [19100]=true, [19103]=true, [19104]=true, [19107]=true,
    [19108]=true, [14590]=true, [19109]=true, [19110]=true,
}

-- Print new migrants
print("\n=== NEW MIGRANTS ===")
local new_migrants = {}
for _, c in ipairs(citizens) do
    if not known[c.id] then
        print(string.format("  %s id=%d prof=%s", c.name, c.id, c.prof))
        table.insert(new_migrants, c)
    end
end

-- Enable hauling on all new migrants first
print("\n=== ASSIGNING LABORS ===")
local hauling_labors = {
    df.unit_labor.HAUL_STONE, df.unit_labor.HAUL_WOOD,
    df.unit_labor.HAUL_BODY, df.unit_labor.HAUL_FOOD,
    df.unit_labor.HAUL_REFUSE, df.unit_labor.HAUL_ITEM,
    df.unit_labor.HAUL_FURNITURE, df.unit_labor.HAUL_ANIMALS,
    df.unit_labor.CLEAN,
}

for _, c in ipairs(new_migrants) do
    -- Enable hauling on everyone
    for _, labor in ipairs(hauling_labors) do
        c.unit.status.labors[labor] = true
    end
end
print(string.format("  Enabled hauling on %d new migrants", #new_migrants))

-- Assign specialized labors based on profession
local role_count = {miner=0, mason=0, carpenter=0, brewer=0, crafter=0, farmer=0, cook=0, soldier=0}
for _, c in ipairs(new_migrants) do
    local prof = c.prof
    -- Enable their existing profession labor
    if prof == "MINER" then
        c.unit.status.labors[df.unit_labor.MINE] = true
        role_count.miner = role_count.miner + 1
    elseif prof == "MASON" or prof == "STONECRAFTER" then
        c.unit.status.labors[df.unit_labor.MASON] = true
        c.unit.status.labors[df.unit_labor.STONE_CRAFT] = true
        role_count.mason = role_count.mason + 1
    elseif prof == "CARPENTER" or prof == "WOODCRAFTER" then
        c.unit.status.labors[df.unit_labor.CARPENTER] = true
        role_count.carpenter = role_count.carpenter + 1
    elseif prof == "BREWER" or prof == "COOK" then
        c.unit.status.labors[df.unit_labor.BREWER] = true
        c.unit.status.labors[df.unit_labor.COOK] = true
        role_count.brewer = role_count.brewer + 1
    elseif prof == "FARMER" or prof == "PLANTER" or prof == "HERBALIST" then
        c.unit.status.labors[df.unit_labor.PLANT] = true
        c.unit.status.labors[df.unit_labor.HERBALIST] = true
        role_count.farmer = role_count.farmer + 1
    elseif prof == "CRAFTSMAN" then
        c.unit.status.labors[df.unit_labor.STONE_CRAFT] = true
        role_count.crafter = role_count.crafter + 1
    end
end

-- For peasants/unknowns, assign mining and crafting
local unassigned = 0
for _, c in ipairs(new_migrants) do
    local prof = c.prof
    if prof == "STANDARD" or prof == "PEASANT" or prof == "CHILD" then
        -- Skip children
        if not dfhack.units.isChild(c.unit) then
            if role_count.miner < 4 then
                c.unit.status.labors[df.unit_labor.MINE] = true
                role_count.miner = role_count.miner + 1
            elseif role_count.crafter < 4 then
                c.unit.status.labors[df.unit_labor.STONE_CRAFT] = true
                role_count.crafter = role_count.crafter + 1
            elseif role_count.carpenter < 3 then
                c.unit.status.labors[df.unit_labor.CARPENTER] = true
                role_count.carpenter = role_count.carpenter + 1
            elseif role_count.farmer < 3 then
                c.unit.status.labors[df.unit_labor.PLANT] = true
                c.unit.status.labors[df.unit_labor.HERBALIST] = true
                role_count.farmer = role_count.farmer + 1
            end
            unassigned = unassigned + 1
        end
    end
end

print("  Role assignments:")
for role, count in pairs(role_count) do
    if count > 0 then print(string.format("    %s: %d", role, count)) end
end
