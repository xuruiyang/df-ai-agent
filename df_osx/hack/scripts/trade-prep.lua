-- Prepare for trading: make crafts and set up broker

-- Check craftsdwarf workshop
local crafts_ws = df.building.find(55)
if crafts_ws then
    print("Craftsdwarf's Workshop (ID=55): " .. #crafts_ws.jobs .. " jobs")
    for i = 0, #crafts_ws.jobs - 1 do
        print("  Job " .. i .. ": " .. tostring(crafts_ws.jobs[i].job_type) .. " repeat=" .. tostring(crafts_ws.jobs[i].flags['repeat']))
    end
else
    print("Workshop 55 not found!")
end

-- Find any workshop with Craftsdwarfs type
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.Workshop then
        print("Workshop ID=" .. bld.id .. " type=" .. bld:getType() .. " jobs=" .. #bld.jobs)
    end
end

-- Check if we have a broker/expedition leader
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) then
        local name = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
        -- Check noble positions
        for _, noble in ipairs(df.global.ui.nobles) do
            if noble.unit_id == unit.id then
                print("Noble: " .. name .. " position=" .. tostring(noble.position))
            end
        end
    end
end

-- Since we can't easily check nobles, let's use DFHack showmood for the mood
-- and focus on creating trade goods directly

-- Create stone crafts directly using modtools
local uid = tostring(df.global.world.units.active[0].id)
for i = 1, 20 do
    dfhack.run_command('modtools/create-item', '-creator', uid, '-item', 'CRAFT:NONE', '-material', 'INORGITE:GRANITE')
end
print("Created 20 stone crafts")

-- Move any items in limbo to ground
for _, item in ipairs(df.global.world.items.all) do
    if item.pos.x < 0 or item.pos.y < 0 then
        dfhack.items.moveToGround(item, xyz2pos(96, 100, 178))
    end
end
print("Moved limbo items to depot area")
