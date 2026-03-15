-- Find wall tiles on z94 near the fortress area
print("=== WALL TILES ON z94 ===")
local walls = {}
for x = 75, 115 do
    for y = 75, 115 do
        local block = dfhack.maps.getTileBlock(x, y, 94)
        if block then
            local lx = x % 16
            local ly = y % 16
            local tt = block.tiletype[lx][ly]
            if df.tiletype.attrs[tt].shape == df.tiletype_shape.WALL then
                table.insert(walls, {x=x, y=y})
            end
        end
    end
end
print(string.format("Wall tiles on z94: %d", #walls))
if #walls > 0 then
    -- Find closest wall to (94,100)
    table.sort(walls, function(a,b)
        return (math.abs(a.x-94) + math.abs(a.y-100)) < (math.abs(b.x-94) + math.abs(b.y-100))
    end)
    for i = 1, math.min(5, #walls) do
        print(string.format("  (%d,%d) dist=%d", walls[i].x, walls[i].y, 
            math.abs(walls[i].x-94) + math.abs(walls[i].y-100)))
    end
end
