-- Fill noble positions: Manager, Broker, Bookkeeper
local positions = df.global.ui.main.fortress_entity.positions
local assignments = df.global.ui.main.fortress_entity.positions.assignments

-- Get citizen historical figures
local citizen_hfs = {}
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) and not dfhack.units.isChild(unit) then
        local hf_id = cycleOccupancy
    end
end

-- Simpler: find unit's histfig via hist_figure_id field
local function get_histfig(unit)
    return unit.hist_figure_id
end

-- Find units for roles
local citizens = {}
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) and not dfhack.units.isChild(unit) then
        table.insert(citizens, unit)
    end
end

print(string.format("Found %d adult citizens", #citizens))

-- Map position names to assignment indices
local pos_map = {}
for i, asgn in ipairs(assignments) do
    for _, pos in ipairs(positions.own) do
        if pos.id == asgn.position_id then
            pos_map[pos.name[0]] = {asgn=asgn, idx=i}
            break
        end
    end
end

-- Assign Manager (pick Urist, the expedition leader - they often double up)
-- Actually pick someone else - let's use Os (peasant 5787) as manager
local function assign_noble(role_name, unit)
    local entry = pos_map[role_name]
    if not entry then
        print(string.format("  Position '%s' not found", role_name))
        return
    end
    if entry.asgn.histfig >= 0 then
        print(string.format("  %s already filled", role_name))
        return
    end
    local hf_id = get_histfig(unit)
    if hf_id < 0 then
        print(string.format("  %s has no histfig", dfhack.TranslateName(dfhack.units.getVisibleName(unit))))
        return
    end
    entry.asgn.histfig = hf_id
    local name = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
    print(string.format("  Appointed %s as %s", name, role_name))
end

-- Find specific units by ID
local os_unit = df.unit.find(5787)        -- Peasant -> Manager
local rakust_unit = df.unit.find(3419)    -- Peasant -> Broker + Bookkeeper
local litast_unit = df.unit.find(18995)   -- Engraver -> Bookkeeper

if os_unit then assign_noble("manager", os_unit) end
if rakust_unit then assign_noble("broker", rakust_unit) end
if litast_unit then assign_noble("bookkeeper", litast_unit) end
