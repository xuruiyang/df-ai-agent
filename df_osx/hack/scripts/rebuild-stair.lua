-- Remove the ramp at (94,100,z94) and build correct stair

-- Find and remove the construction building
for i, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.Construction and bld.x1 == 94 and bld.y1 == 100 and bld.z == 94 then
        print(string.format("Found construction id=%d, removing...", bld.id))
        dfhack.buildings.deconstruct(bld)
        print("Removed!")
        break
    end
end

-- Now build correct UpDownStair (construction_type=5)
local pos = xyz2pos(94, 100, 94)
local bld = dfhack.buildings.allocInstance(pos, df.building_type.Construction, 5, -1)  -- 5 = UpDownStair
if not bld then
    print("Failed to allocate UpDownStair construction!")
    return
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
    -- Verify
    local block = dfhack.maps.getTileBlock(94, 100, 94)
    if block then
        local lx = 94 % 16
        local ly = 100 % 16
        local tt = block.tiletype[lx][ly]
        local shape = df.tiletype.attrs[tt].shape
        print(string.format("Built! tiletype=%d shape=%s (%d)", tt, tostring(shape), shape))
    end
else
    print("Failed: " .. tostring(err))
end
