-- Find surface elevation at sample points across the map
local map_x = df.global.world.map.x_count
local map_y = df.global.world.map.y_count
local map_z = df.global.world.map.z_count
print(string.format("Map size: %dx%dx%d", map_x, map_y, map_z))

local max_surface_z = 0
local max_surface_pos = ""

for sx = 10, map_x - 10, 30 do
    for sy = 10, map_y - 10, 30 do
        -- Find surface: highest z with a non-empty tile
        for sz = map_z - 1, 90, -1 do
            local block = dfhack.maps.getTileBlock(sx, sy, sz)
            if block then
                local lx = sx % 16
                local ly = sy % 16
                local tiletype = block.tiletype[lx][ly]
                local attrs = df.tiletype.attrs[tiletype]
                local shape = attrs.shape
                if shape ~= df.tiletype_shape.EMPTY and shape ~= df.tiletype_shape.NONE then
                    if sz > max_surface_z then
                        max_surface_z = sz
                        max_surface_pos = string.format("(%d,%d)", sx, sy)
                    end
                    break
                end
            end
        end
    end
end

print(string.format("Highest terrain: z=%d at %s", max_surface_z, max_surface_pos))
print(string.format("Our surface: z=97 at (94,100)"))
print(string.format("Difference: %d z-levels", max_surface_z - 97))
