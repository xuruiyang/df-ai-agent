-- Appoint key nobles: Manager, Broker, Bookkeeper
-- Manager: enables manager work orders
-- Broker: enables trading at depot
-- Bookkeeper: enables precise stock counts

local race_id = df.global.ui.race_id
local citizens = {}
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) and not dfhack.units.isChild(unit) then
        table.insert(citizens, unit)
    end
end

-- Find existing positions
local positions = df.global.ui.main.fortress_entity.positions
print(string.format("Entity has %d position types", #positions.own))

for _, pos in ipairs(positions.own) do
    print(string.format("  Position: %s (id=%d)", pos.name[0], pos.id))
end

-- Try to assign manager, broker, bookkeeper
-- These are typically assigned from the nobles screen
-- In DFHack, we can directly set the assignments

local assignments = df.global.ui.main.fortress_entity.positions.assignments
print(string.format("\n%d assignments:", #assignments))
for _, asgn in ipairs(assignments) do
    local pos = nil
    for _, p in ipairs(positions.own) do
        if p.id == asgn.position_id then pos = p; break end
    end
    local holder = "VACANT"
    if asgn.histfig >= 0 then
        local hf = df.historical_figure.find(asgn.histfig)
        if hf then
            holder = dfhack.TranslateName(hf.name)
        end
    end
    local pos_name = pos and pos.name[0] or "?"
    print(string.format("  %s: %s (histfig=%d)", pos_name, holder, asgn.histfig))
end
