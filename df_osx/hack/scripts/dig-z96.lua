-- Set up/down stair at (92,100,96) connecting to the entrance above
local x, y, z = 92, 100, 96
local block = dfhack.maps.getTileBlock(x, y, z)
if block then
    block.designation[x%16][y%16].dig = df.tile_dig_designation.UpDownStair
    block.flags.designated = true
end

-- Set up main corridor on z96: east-west from (82,100) to (100,100), width 3
for cx = 82, 100 do
    for cy = 99, 101 do
        if cx ~= 92 or cy ~= 100 then  -- skip the stair spot
            local b = dfhack.maps.getTileBlock(cx, cy, 96)
            if b then
                b.designation[cx%16][cy%16].dig = df.tile_dig_designation.Default
                b.flags.designated = true
            end
        end
    end
end

-- Workshop area south: 11x11 room at (86, 103, 96)
for cx = 86, 96 do
    for cy = 103, 113 do
        local b = dfhack.maps.getTileBlock(cx, cy, 96)
        if b then
            b.designation[cx%16][cy%16].dig = df.tile_dig_designation.Default
            b.flags.designated = true
        end
    end
end

-- Connect corridor to workshop area
for cy = 101, 103 do
    local b = dfhack.maps.getTileBlock(92, cy, 96)
    if b then
        b.designation[92%16][cy%16].dig = df.tile_dig_designation.Default
        b.flags.designated = true
    end
end

-- Farm area north: 10x10 at (85, 89, 96)
for cx = 85, 94 do
    for cy = 89, 98 do
        local b = dfhack.maps.getTileBlock(cx, cy, 96)
        if b then
            b.designation[cx%16][cy%16].dig = df.tile_dig_designation.Default
            b.flags.designated = true
        end
    end
end

-- Connect corridor to farm area
for cy = 98, 99 do
    local b = dfhack.maps.getTileBlock(92, cy, 96)
    if b then
        b.designation[92%16][cy%16].dig = df.tile_dig_designation.Default
        b.flags.designated = true
    end
end

-- Bedroom hallway and rooms east: hallway at x=101, y=97 to 103
for cy = 97, 103 do
    local b = dfhack.maps.getTileBlock(101, cy, 96)
    if b then
        b.designation[101%16][cy%16].dig = df.tile_dig_designation.Default
        b.flags.designated = true
    end
end

-- 7 bedrooms (3x2 each) branching east
for i = 0, 6 do
    local by = 97 + i
    for cx = 102, 104 do
        for cy = by, by do
            local b = dfhack.maps.getTileBlock(cx, cy, 96)
            if b then
                b.designation[cx%16][cy%16].dig = df.tile_dig_designation.Default
                b.flags.designated = true
            end
        end
    end
end

-- Now run dig-now to instantly complete
dfhack.run_command("dig-now")
print("dig-now completed - z96 fortress layout dug")
