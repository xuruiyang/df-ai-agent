-- Verify z94 stair was carved and build connecting stairs
-- Check (94,106,z94)
local block94 = dfhack.maps.getTileBlock(94, 106, 94)
if block94 then
    local lx = 94 % 16
    local ly = 106 % 16
    local tt = block94.tiletype[lx][ly]
    local shape = df.tiletype.attrs[tt].shape
    print(string.format("(94,106,z94): shape=%s (%d) tiletype=%d", tostring(shape), shape, tt))
end

-- Build constructed DownStair at (94,106,z95) connecting down to z94
local pos95 = xyz2pos(94, 106, 95)
local bld95 = dfhack.buildings.allocInstance(pos95, df.building_type.Construction, 4, -1)  -- 4=DownStair
if bld95 then
    local stone = nil
    for _, item in ipairs(df.global.world.items.all) do
        if item:getType() == df.item_type.BOULDER and not item.flags.in_building and not item.flags.forbid and not item.flags.in_job then
            stone = item; break
        end
    end
    if stone then
        local ok, err = pcall(function()
            dfhack.buildings.constructWithItems(bld95, {stone})
        end)
        if ok then
            local b = dfhack.maps.getTileBlock(94, 106, 95)
            local tt = b.tiletype[94%16][106%16]
            local shape = df.tiletype.attrs[tt].shape
            print(string.format("Built DownStair at (94,106,z95): shape=%s (%d)", tostring(shape), shape))
        else
            print("Failed z95: " .. tostring(err))
        end
    end
end

-- Build constructed UpStair at (94,106,z93) connecting up to z94
local pos93 = xyz2pos(94, 106, 93)
local bld93 = dfhack.buildings.allocInstance(pos93, df.building_type.Construction, 3, -1)  -- 3=UpStair
if bld93 then
    local stone = nil
    for _, item in ipairs(df.global.world.items.all) do
        if item:getType() == df.item_type.BOULDER and not item.flags.in_building and not item.flags.forbid and not item.flags.in_job then
            stone = item; break
        end
    end
    if stone then
        local ok, err = pcall(function()
            dfhack.buildings.constructWithItems(bld93, {stone})
        end)
        if ok then
            local b = dfhack.maps.getTileBlock(94, 106, 93)
            local tt = b.tiletype[94%16][106%16]
            local shape = df.tiletype.attrs[tt].shape
            print(string.format("Built UpStair at (94,106,z93): shape=%s (%d)", tostring(shape), shape))
        else
            print("Failed z93: " .. tostring(err))
        end
    end
end
