-- Dig a tunnel from our fortress to the water source
-- Our underground hall is at roughly (93-110, 107-116, z=177)
-- Water is at (60, 104, z=177)
-- We need a tunnel from x=93 westward to x=60 at y=110, z=177

-- First, dig the tunnel on z=177 from our hall to the water
-- Dig a 3-wide corridor from x=92 to x=58, y=109-111, z=177
local function designate_area(x1, y1, z, w, h, dtype)
    local count = 0
    for x = x1, x1 + w - 1 do
        for y = y1, y1 + h - 1 do
            local block = dfhack.maps.getTileBlock(x, y, z)
            if block then
                local lx = x % 16
                local ly = y % 16
                local tt = block.tiletype[lx][ly]
                local shape = df.tiletype.attrs[tt].shape
                if shape == df.tiletype_shape.WALL then
                    block.designation[lx][ly].dig = dtype
                    block.flags.designated = true
                    count = count + 1
                end
            end
        end
    end
    return count
end

-- Dig tunnel from our hall (x=93) west to water (x=58)
local tunnel_count = designate_area(58, 109, 177, 35, 3, df.tile_dig_designation.Default)
print("Tunnel designation: " .. tunnel_count .. " tiles")

-- Dig a small cistern room around the water source
local cistern_count = designate_area(55, 101, 177, 10, 10, df.tile_dig_designation.Default)
print("Cistern room designation: " .. cistern_count .. " tiles")

-- Also dig a well shaft up from z=177 to z=178 at (62, 108)
-- We'll channel down from z=178 into z=177 at the cistern location
local channel_count = 0
for x = 60, 62 do
    for y = 108, 110 do
        local block = dfhack.maps.getTileBlock(x, y, 178)
        if block then
            local lx = x % 16
            local ly = y % 16
            block.designation[lx][ly].dig = df.tile_dig_designation.Channel
            block.flags.designated = true
            channel_count = channel_count + 1
        end
    end
end
print("Channel designation (z=178): " .. channel_count .. " tiles")

-- Use dig-now to instantly complete
print("Running dig-now...")
dfhack.run_command('dig-now')
print("Digging complete!")

-- Check if water is now accessible
local water_tiles = 0
for x = 55, 70 do
    for y = 100, 115 do
        local block = dfhack.maps.getTileBlock(x, y, 177)
        if block then
            local lx = x % 16
            local ly = y % 16
            if block.designation[lx][ly].flow_size > 0 then
                water_tiles = water_tiles + 1
            end
        end
    end
end
print("Water tiles in cistern area: " .. water_tiles)
