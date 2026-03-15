-- Check stone availability and dig more if needed
print("=== STONE COUNTS ===")
local stone_free = 0
local stone_total = 0
local stone_econ = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BOULDER then
        stone_total = stone_total + 1
        if not item.flags.in_building and not item.flags.forbid and not item.flags.in_job then
            -- Check if economic (ore, gem-bearing, etc)
            local mat_info = dfhack.matinfo.decode(item)
            if mat_info then
                local flags = mat_info.inorganic.flags
                if flags.ITE_GENERIC or not (flags.ITE_ORE or flags.SPECIAL) then
                    stone_free = stone_free + 1
                else
                    stone_econ = stone_econ + 1
                end
            else
                stone_free = stone_free + 1
            end
        end
    end
end
print(string.format("  Total boulders: %d, Free non-economic: %d, Economic: %d", stone_total, stone_free, stone_econ))

-- Check what's on z93 and z92 (our dug levels)
print("\n=== DIGGING STATUS ===")
-- Count undug tiles on z91 (next level to dig)
local undug_91 = 0
local undug_90 = 0
for x = 80, 110 do
    for y = 80, 110 do
        local block91 = dfhack.maps.getTileBlock(x, y, 91)
        if block91 then
            local lx = x % 16
            local ly = y % 16
            local tt = block91.tiletype[lx][ly]
            local shape = df.tiletype.attrs[tt].shape
            if shape == df.tiletype_shape.WALL then
                undug_91 = undug_91 + 1
            end
        end
    end
end
print(string.format("  Undug wall tiles on z91 (80-110,80-110): %d", undug_91))

-- Designate a big area on z91 for digging
print("\n=== DESIGNATING z91 for digging ===")
local designated = 0
for x = 82, 108 do
    for y = 82, 108 do
        local block = dfhack.maps.getTileBlock(x, y, 91)
        if block then
            local lx = x % 16
            local ly = y % 16
            local tt = block.tiletype[lx][ly]
            local shape = df.tiletype.attrs[tt].shape
            if shape == df.tiletype_shape.WALL then
                local occ = cycleOccupancy
            end
        end
    end
end

-- Use designate_dig bridge function approach
-- Actually let's use dfhack.maps designation
for x = 82, 108 do
    for y = 82, 108 do
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
print(string.format("  Designated %d tiles on z91 for mining", designated))

-- Also need down stair access
-- Put a down stair at (95,95,z92) connecting to z91
local block92 = dfhack.maps.getTileBlock(95, 95, 92)
if block92 then
    local lx = 95 % 16
    local ly = 95 % 16
    block92.designation[lx][ly].dig = df.tile_dig_designation.DownStair
    block92.flags.designated = true
    print("  Designated down stair at (95,95,z92)")
end

-- Up/down stair at (95,95,z91)
local block91 = dfhack.maps.getTileBlock(95, 95, 91)
if block91 then
    local lx = 95 % 16
    local ly = 95 % 16
    block91.designation[lx][ly].dig = df.tile_dig_designation.UpDownStair
    block91.flags.designated = true
    print("  Designated up/down stair at (95,95,z91)")
end
