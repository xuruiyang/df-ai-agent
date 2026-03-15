local EX, EY = 94, 100

-- Extend stairway to z95
local b96 = dfhack.maps.getTileBlock(EX, EY, 96)
if b96 then
    -- Make sure z96 stair goes down too
    local tt = b96.tiletype[EX%16][EY%16]
    local shape = df.tiletype_shape[df.tiletype.attrs[tt].shape] or "?"
    if shape ~= "STAIR_UPDOWN" then
        -- Find STAIR_UPDOWN in same material
        local mat = df.tiletype_material[df.tiletype.attrs[tt].material] or "?"
        for i = 0, 600 do
            local a = df.tiletype.attrs[i]
            if a and df.tiletype_shape[a.shape] == "STAIR_UPDOWN" and df.tiletype_material[a.material] == mat then
                b96.tiletype[EX%16][EY%16] = i; break
            end
        end
    end
end

-- Dig z95: stair + big storage area
local b95 = dfhack.maps.getTileBlock(EX, EY, 95)
if b95 then
    b95.designation[EX%16][EY%16].dig = df.tile_dig_designation.UpDownStair
    b95.flags.designated = true
end

-- Big 20x20 area for stone and storage
for cx = EX-10, EX+9 do
    for cy = EY-10, EY+9 do
        if cx ~= EX or cy ~= EY then
            local b = dfhack.maps.getTileBlock(cx, cy, 95)
            if b then
                b.designation[cx%16][cy%16].dig = df.tile_dig_designation.Default
                b.flags.designated = true
            end
        end
    end
end

dfhack.run_command("dig-now")
print("Z95 storage level dug (20x20)")

-- Verify stairway
for z = 95, 97 do
    local b = dfhack.maps.getTileBlock(EX, EY, z)
    if b then
        local tt = b.tiletype[EX%16][EY%16]
        print(string.format("z%d stair: %s", z, df.tiletype_shape[df.tiletype.attrs[tt].shape] or "?"))
    end
end
