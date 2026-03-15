-- Count available boulders and dig z91
print("=== BOULDERS ===")
local free = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BOULDER and not item.flags.in_building and not item.flags.forbid and not item.flags.in_job then
        free = free + 1
    end
end
print(string.format("  Free boulders: %d", free))

-- Designate z91 for digging (27x27 area)
print("\n=== DIGGING z91 ===")
local designated = 0

-- First make stair access from z92 down to z91
-- Check if there's already a stair at (95,95,z92)
local block92 = dfhack.maps.getTileBlock(95, 95, 92)
if block92 then
    local lx = 95 % 16
    local ly = 95 % 16
    local tt = block92.tiletype[lx][ly]
    local shape = df.tiletype.attrs[tt].shape
    if shape ~= df.tiletype_shape.STAIR_DOWN and shape ~= df.tiletype_shape.STAIR_UPDOWN then
        block92.designation[lx][ly].dig = df.tile_dig_designation.DownStair
        block92.flags.designated = true
        print("  Down stair designated at (95,95,z92)")
    else
        print("  Stair already exists at (95,95,z92)")
    end
end

-- Up/down stair at center of z91
local block91c = dfhack.maps.getTileBlock(95, 95, 91)
if block91c then
    local lx = 95 % 16
    local ly = 95 % 16
    block91c.designation[lx][ly].dig = df.tile_dig_designation.UpDownStair
    block91c.flags.designated = true
    print("  Up/down stair designated at (95,95,z91)")
end

-- Dig out z91 (30x30 area)
for x = 80, 109 do
    for y = 80, 109 do
        if not (x == 95 and y == 95) then  -- skip stair
            local block = dfhack.maps.getTileBlock(x, y, 91)
            if block then
                local lx = x % 16
                local ly = y % 16
                local tt = block.tiletype[lx][ly]
                local shape = df.tiletype.attrs[tt].shape
                if shape == df.tiletype_shape.WALL then
                    block.designation[lx][ly].dig = df.tile_dig_designation.Default
                    block.flags.designated = true
                    designated = designated + 1
                end
            end
        end
    end
end
print(string.format("  Designated %d tiles on z91", designated))
