-- Request trade at the depot
local depot = df.building.find(7)
if not depot then
    print("ERROR: Trade depot not found")
    return
end

print("Requesting trader and goods at depot...")
depot.trade_flags.trader_requested = true

-- Check caravan status via announcements
-- The merchants are unloading, we need a broker to trade
-- Find our broker/expedition leader
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) then
        local prof = df.profession[unit.profession]
        if prof and (prof:lower():find("expedition") or prof:lower():find("broker") or prof:lower():find("leader")) then
            print("Found leader: " .. dfhack.TranslateName(dfhack.units.getVisibleName(unit)) .. " (" .. prof .. ")")
        end
    end
end

-- Enable TRADE labor on our expedition leader (Sazir, ID=5088)
print("Note: Make sure expedition leader has TRADE labor enabled")
