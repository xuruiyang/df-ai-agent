-- Create a military squad with best fighters
-- Vucar (19109, combat=11), Deduk (7462, combat=3), Litast (18995, combat=1)

local entity = df.global.ui.main.fortress_entity

-- Create squad
local squad = df.squad:new()
squad.id = df.global.squad_next_id
df.global.squad_next_id = df.global.squad_next_id + 1

-- Set name
squad.name.first_name = "defenders"
squad.name.nickname = "Defenders"

-- Set entity
squad.entity_id = entity.id

-- Add to world
df.global.world.squads.all:insert('#', squad)
entity.squads:insert('#', squad.id)

-- Initialize positions (squads have 10 slots)
for i = 0, 9 do
    local pos = df.squad_position:new()
    pos.occupant = -1
    squad.positions:insert('#', pos)
end

-- Assign soldiers
local soldiers = {19109, 7462}  -- Vucar (best) and Deduk
local assigned = 0
for slot, uid in ipairs(soldiers) do
    local unit = df.unit.find(uid)
    if unit and dfhack.units.isAlive(unit) then
        local hf_id = unit.hist_figure_id
        if hf_id >= 0 then
            squad.positions[slot-1].occupant = hf_id
            assigned = assigned + 1
            local name = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
            print(string.format("  Assigned %s (id=%d) to squad slot %d", name, uid, slot-1))
        end
    end
end

print(string.format("Created squad 'Defenders' id=%d with %d members", squad.id, assigned))
print("Squad will need to be given a kill order on Urdim via the military screen")
