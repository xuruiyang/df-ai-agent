-- Assign bedrooms using DFHack API
local beds = {}
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.Bed and bld.flags.exists and bld.is_room then
        table.insert(beds, bld)
    end
end

local citizens = {}
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) then
        table.insert(citizens, unit)
    end
end

print("Bedrooms: " .. #beds .. ", Citizens: " .. #citizens)

local assigned = 0
for i, bed in ipairs(beds) do
    if i <= #citizens then
        local unit = citizens[i]
        -- Use DFHack buildings API to assign
        dfhack.buildings.setOwner(bed, unit)
        local name = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
        print(string.format("  Bedroom -> %s", name))
        assigned = assigned + 1
    end
end
print("Assigned " .. assigned .. " bedrooms")
