-- Find deep water closer to our fortress (around x=100, y=105)
-- Check z=149 area more carefully
print("Deep water on z=149 near fortress (x=80-120, y=80-120):")
local deep_tiles = {}
for x = 80, 120 do
    for y = 80, 120 do
        local block = dfhack.maps.getTileBlock(x, y, 149)
        if block then
            local lx = x % 16
            local ly = y % 16
            local flow = block.designation[lx][ly].flow_size
            if flow >= 4 then
                table.insert(deep_tiles, {x=x, y=y, flow=flow})
            end
        end
    end
end
print("Deep water tiles (flow>=4) near fortress: " .. #deep_tiles)
for i = 1, math.min(10, #deep_tiles) do
    print(string.format("  %d,%d flow=%d", deep_tiles[i].x, deep_tiles[i].y, deep_tiles[i].flow))
end

-- Check z=148
print("\nDeep water on z=148 near fortress:")
deep_tiles = {}
for x = 60, 120 do
    for y = 80, 120 do
        local block = dfhack.maps.getTileBlock(x, y, 148)
        if block then
            local lx = x % 16
            local ly = y % 16
            local flow = block.designation[lx][ly].flow_size
            if flow >= 4 then
                table.insert(deep_tiles, {x=x, y=y, flow=flow})
            end
        end
    end
end
print("Deep water tiles on z=148: " .. #deep_tiles)
for i = 1, math.min(10, #deep_tiles) do
    print(string.format("  %d,%d flow=%d", deep_tiles[i].x, deep_tiles[i].y, deep_tiles[i].flow))
end

-- Alternative: build a cistern on z=177 and fill it with water via source
-- We could also dig a 1x1 hole downward until we hit water, then channel
-- Check what's directly below our fortress at various z-levels
print("\nScanning directly below fortress (100,110) for water:")
for z = 177, 140, -1 do
    local block = dfhack.maps.getTileBlock(100, 110, z)
    if block then
        local lx = 100 % 16
        local ly = 110 % 16
        local flow = block.designation[lx][ly].flow_size
        local tt = block.tiletype[lx][ly]
        local shape = df.tiletype.attrs[tt].shape
        if flow > 0 or shape ~= df.tiletype_shape.WALL then
            print(string.format("  z=%d: shape=%s flow=%d", z, df.tiletype_shape[shape], flow))
        end
    end
end
