-- Build a water access system
-- Strategy:
-- 1. Dig a vertical shaft from (60,110,z=177) down to z=148 where deep water is
-- 2. The water will flow up through the shaft
-- 3. Build a well at z=178 above the shaft
-- 4. The tunnel from our fortress to (60,110) on z=177 is already dug

-- Step 1: Dig shaft down from z=176 to z=149 (z=177 is already dug, z=148 has water)
print("Digging vertical shaft from z=176 to z=149 at (60,110)...")
local shaft_dug = 0
for z = 176, 149, -1 do
    for x = 60, 61 do
        for y = 110, 111 do
            local block = dfhack.maps.getTileBlock(x, y, z)
            if block then
                local lx = x % 16
                local ly = y % 16
                local tt = block.tiletype[lx][ly]
                local shape = df.tiletype.attrs[tt].shape
                if shape == df.tiletype_shape.WALL then
                    block.designation[lx][ly].dig = df.tile_dig_designation.DownStair
                    block.flags.designated = true
                    shaft_dug = shaft_dug + 1
                end
            end
        end
    end
end
print("Shaft designated: " .. shaft_dug .. " tiles")

-- Also make sure z=177 at (60,110) has down stairs
for x = 60, 61 do
    for y = 110, 111 do
        local block = dfhack.maps.getTileBlock(x, y, 177)
        if block then
            local lx = x % 16
            local ly = y % 16
            local tt = block.tiletype[lx][ly]
            local shape = df.tiletype.attrs[tt].shape
            if shape == df.tiletype_shape.FLOOR then
                -- Channel down
                block.designation[lx][ly].dig = df.tile_dig_designation.Channel
                block.flags.designated = true
            end
        end
    end
end

-- Step 2: Channel from z=148 into the water
-- The water at z=148 is at (60-63, 110-115)
-- We need to connect our shaft to the water
for x = 60, 61 do
    for y = 110, 111 do
        local block = dfhack.maps.getTileBlock(x, y, 148)
        if block then
            local lx = x % 16
            local ly = y % 16
            local tt = block.tiletype[lx][ly]
            local shape = df.tiletype.attrs[tt].shape
            if shape == df.tiletype_shape.WALL then
                block.designation[lx][ly].dig = df.tile_dig_designation.Default
                block.flags.designated = true
            end
        end
    end
end

-- Step 3: Dig-now to complete everything
print("Running dig-now...")
dfhack.run_command('dig-now')

-- Step 4: Check if water is accessible at z=177
print("\nChecking water levels after digging...")
for z = 177, 148, -1 do
    local block = dfhack.maps.getTileBlock(60, 110, z)
    if block then
        local lx = 60 % 16
        local ly = 110 % 16
        local flow = block.designation[lx][ly].flow_size
        local tt = block.tiletype[lx][ly]
        local shape = df.tiletype.attrs[tt].shape
        if flow > 0 or z >= 175 or z <= 150 then
            print(string.format("  z=%d: shape=%s flow=%d", z, df.tiletype_shape[shape], flow))
        end
    end
end

-- Step 5: Build well at surface near the shaft
-- First we need to make sure there's a floor at z=178 above the shaft
-- Check z=178
print("\nChecking z=178 above shaft for well placement...")
local block178 = dfhack.maps.getTileBlock(60, 110, 178)
if block178 then
    local lx = 60 % 16
    local ly = 110 % 16
    local tt = block178.tiletype[lx][ly]
    local shape = df.tiletype.attrs[tt].shape
    local flow = block178.designation[lx][ly].flow_size
    print(string.format("  z=178 at 60,110: shape=%s flow=%d", df.tiletype_shape[shape], flow))
end

print("\nWater system shaft complete!")
print("Water needs time to flow up through the shaft.")
print("Once water reaches z=177, we can build a well at z=178.")
