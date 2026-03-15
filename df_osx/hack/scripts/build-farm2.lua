-- Build a second farm plot
local function is_farmable(x, y, z)
    local tt = dfhack.maps.getTileType(x, y, z)
    if not tt then return false end
    local mat = df.tiletype.attrs[tt].material
    return mat == df.tiletype_material.SOIL or mat == df.tiletype_material.GRASS_LIGHT or mat == df.tiletype_material.GRASS_DARK
end

-- Try to find another 3x3 farmable area (avoiding 92,94 where we already placed one)
for sy = 93, 108 do
    for sx = 85, 100 do
        -- Skip already used area
        if sx >= 90 and sx <= 94 and sy >= 92 and sy <= 96 then
            goto continue
        end
        local ok = true
        for dx = 0, 2 do
            for dy = 0, 2 do
                if not is_farmable(sx+dx, sy+dy, 178) then
                    ok = false
                    break
                end
            end
            if not ok then break end
        end
        if ok then
            local farm = dfhack.buildings.constructBuilding{
                type = df.building_type.FarmPlot,
                pos = xyz2pos(sx, sy, 178),
                width = 3,
                height = 3,
            }
            if farm then
                print("Second farm plot at " .. sx .. "," .. sy .. ",178 ID=" .. farm.id)
                return
            end
        end
        ::continue::
    end
end
print("Could not find another farmable area")
