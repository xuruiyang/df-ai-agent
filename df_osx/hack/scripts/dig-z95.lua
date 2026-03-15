-- Dig a second fortress level at z95 for stockpiles and storage
-- First, extend the stairway down
local x, y = 92, 100

-- Up/down stair at z96 should already exist, but let's make sure
-- Dig down stair at z96 position (add stairs going down)
local block96 = dfhack.maps.getTileBlock(x, y, 96)
if block96 then
    local tt = block96.tiletype[x%16][y%16]
    local shape = df.tiletype_shape[df.tiletype.attrs[tt].shape] or "?"
    print(string.format("z96 stair: shape=%s", shape))
    -- If it's up/down or down, we're good. If it's just up, need to change to up/down
    if shape == "STAIR_UP" then
        -- Need to find up_down_stair tiletype in same material
        local mat = df.tiletype_material[df.tiletype.attrs[tt].material] or "?"
        for i = 0, 600 do
            local a = df.tiletype.attrs[i]
            if a and df.tiletype_shape[a.shape] == "STAIR_UPDOWN" and 
               df.tiletype_material[a.material] == mat then
                block96.tiletype[x%16][y%16] = i
                print("Changed to STAIR_UPDOWN")
                break
            end
        end
    end
end

-- Designate stairway down at z96 and rooms at z95
local block95 = dfhack.maps.getTileBlock(x, y, 95)
if block95 then
    block95.designation[x%16][y%16].dig = df.tile_dig_designation.UpDownStair
    block95.flags.designated = true
end

-- Dig storage rooms on z95
-- Large stockpile area: 15x15 room
for cx = 85, 99 do
    for cy = 93, 107 do
        if cx ~= 92 or cy ~= 100 then  -- skip stair
            local b = dfhack.maps.getTileBlock(cx, cy, 95)
            if b then
                b.designation[cx%16][cy%16].dig = df.tile_dig_designation.Default
                b.flags.designated = true
            end
        end
    end
end

-- Run dig-now
dfhack.run_command("dig-now")
print("z95 storage level dug!")

-- Verify
local check = dfhack.maps.getTileBlock(92, 100, 95)
if check then
    local tt = check.tiletype[92%16][100%16]
    local shape = df.tiletype_shape[df.tiletype.attrs[tt].shape] or "?"
    print(string.format("z95 stair result: shape=%s", shape))
end
