-- Build constructed up/down stair at (94,100,z94)
-- construction_type: NONE=0, Fortification=1, Wall=2, Floor=3, 
-- UpStair=4, DownStair=5, UpDownStair=6, Ramp=7, TrackN/S/E/W...

local pos = xyz2pos(94, 100, 94)
local bld = dfhack.buildings.allocInstance(pos, df.building_type.Construction, 6, -1)
if not bld then
    print("Failed to allocate construction!")
    -- Try with named constant
    bld = dfhack.buildings.allocInstance(pos, df.building_type.Construction, df.construction_type.UpDownStair, -1)
    if not bld then
        print("Still failed!")
        return
    end
end

-- Find a boulder
local stone = nil
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BOULDER and not item.flags.in_building and not item.flags.forbid and not item.flags.in_job then
        stone = item
        break
    end
end
if not stone then print("No stone!"); return end

local ok, err = pcall(function()
    dfhack.buildings.constructWithItems(bld, {stone})
end)
if ok then
    print("Constructed up/down stair at (94,100,z94)!")
else
    print("Failed: " .. tostring(err))
end
