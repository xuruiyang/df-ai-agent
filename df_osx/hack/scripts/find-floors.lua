-- Find floor tiles on z95 and z96 that don't have buildings
local z95_floors = {}
local z96_floors = {}
for x = 80, 110 do
    for y = 80, 110 do
        for _, z in ipairs({95, 96}) do
            local block = dfhack.maps.getTileBlock(x, y, z)
            if block then
                local lx = x % 16
                local ly = y % 16
                local tt = block.tiletype[lx][ly]
                local shape = df.tiletype.attrs[tt].shape
                if shape == df.tiletype_shape.FLOOR then
                    local occ = block.occupancy[lx][ly]
                    if occ.building == 0 then
                        if z == 95 then
                            table.insert(z95_floors, {x=x, y=y})
                        else
                            table.insert(z96_floors, {x=x, y=y})
                        end
                    end
                end
            end
        end
    end
end
print(string.format("Empty floor tiles: z95=%d, z96=%d", #z95_floors, #z96_floors))

-- Show z95 range
if #z95_floors > 0 then
    local minx, maxx, miny, maxy = 999, 0, 999, 0
    for _, f in ipairs(z95_floors) do
        if f.x < minx then minx = f.x end
        if f.x > maxx then maxx = f.x end
        if f.y < miny then miny = f.y end
        if f.y > maxy then maxy = f.y end
    end
    print(string.format("z95 floor range: x=%d-%d, y=%d-%d", minx, maxx, miny, maxy))
    -- Show first 10
    for i = 1, math.min(10, #z95_floors) do
        print(string.format("  (%d,%d)", z95_floors[i].x, z95_floors[i].y))
    end
end
