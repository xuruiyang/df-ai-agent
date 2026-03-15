-- Check herbalist capacity
local herbalists = 0
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit) and unit.mood < 0 then
        if unit.status.labors[df.unit_labor.HERBALIST] then
            herbalists = herbalists + 1
        end
    end
end
print(string.format("Herbalists: %d", herbalists))

-- Enable herbalist on more dwarves (need at least 10 for mass gathering)
if herbalists < 15 then
    local added = 0
    for _, unit in ipairs(df.global.world.units.active) do
        if dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit) and unit.mood < 0 then
            if not unit.status.labors[df.unit_labor.HERBALIST] and not dfhack.units.isChild(unit) then
                unit.status.labors[df.unit_labor.HERBALIST] = true
                added = added + 1
                if added >= (15 - herbalists) then break end
            end
        end
    end
    print(string.format("Enabled HERBALIST on %d more dwarves (total now: %d)", added, herbalists + added))
end

-- Check surface plant designations
local designated_plants = 0
for _, plant in ipairs(df.global.world.plants.all) do
    if plant.flags.is_shrub and plant.pos.z >= 97 then
        -- Check if designated for gathering
        local block = dfhack.maps.getTileBlock(plant.pos.x, plant.pos.y, plant.pos.z)
        if block then
            local lx = plant.pos.x % 16
            local ly = plant.pos.y % 16
            if block.designation[lx][ly].dig == df.tile_dig_designation.Default then
                designated_plants = designated_plants + 1
            end
        end
    end
end
print(string.format("Surface plants designated: %d", designated_plants))
