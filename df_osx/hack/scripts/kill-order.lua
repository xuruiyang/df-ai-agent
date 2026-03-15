-- Set kill order on berserk Urdim (id=19100)
-- In DF, the military needs a station order or kill order

local squad = df.squad.find(460)
if not squad then
    print("Squad 460 not found!")
    return
end

-- Set squad to active (not schedule-based)
-- Set all months to active
for i = 0, 11 do
    -- Squad schedule: each month has an order list
    if #squad.schedule[i] > 0 then
        squad.schedule[i][0].min_count = 2  -- require 2 soldiers on duty
    end
end

-- Set squad to active duty
squad.cur_alert_idx = 1  -- 1 = active/alert, 0 = inactive

-- Try to create a kill order targeting Urdim
-- Kill orders are stored in army_controller or via orders
-- Actually, the simplest way is to use the station command near Urdim

local urdim = df.unit.find(19100)
if urdim then
    print(string.format("Urdim at (%d,%d,z%d)", urdim.pos.x, urdim.pos.y, urdim.pos.z))

    -- Station the squad near Urdim
    -- Create a station order
    local order = df.squad_order_kill_listst:new()
    order.units:insert('#', urdim.id)
    order.title = "Kill berserk Urdim"

    -- Add to squad orders
    squad.orders:insert('#', order)
    print("Kill order issued on Urdim!")
else
    print("Urdim not found")
end

-- Also activate squad members
for _, pos in ipairs(squad.positions) do
    if pos.occupant >= 0 then
        -- Find the unit
        for _, unit in ipairs(df.global.world.units.active) do
            if unit.hist_figure_id == pos.occupant then
                -- Enable military labors
                unit.status.labors[df.unit_labor.MINE] = false  -- don't mine while soldiering
                local name = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
                print(string.format("  Soldier %s activated", name))
            end
        end
    end
end
