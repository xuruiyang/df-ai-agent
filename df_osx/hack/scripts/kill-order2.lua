-- Issue kill order on berserk Urdim
local squad = df.squad.find(460)
if not squad then print("Squad not found!"); return end

local urdim = df.unit.find(19100)
if not urdim then print("Urdim not found!"); return end

-- Create kill order
local order = df.squad_order_kill_listst:new()
order.units:insert('#', urdim.id)
order.title = "Kill berserk dwarf"
squad.orders:insert('#', order)
print(string.format("Kill order issued targeting Urdim at (%d,%d,z%d)", urdim.pos.x, urdim.pos.y, urdim.pos.z))

-- Set squad alert level to active
squad.cur_alert_idx = 1
print("Squad set to active alert")
