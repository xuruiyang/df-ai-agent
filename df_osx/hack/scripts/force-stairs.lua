-- Force-set stair tiletypes at (94,106) on z95 and z93
-- z94 already has STAIR_UPDOWN (tiletype 55)
-- We need z95 to have a down stair and z93 to have an up stair

-- Look up tiletype values for stairs
-- Tiletype 55 = up/down stair (confirmed at z94)
-- Tiletype 56 = up stair (seen at z93 (94,100))  
-- Tiletype 57 should be down stair

-- Check what tiletypes we've seen for stairs
print("Known stair tiletypes:")
print(string.format("  z94 (94,106): tiletype=55, shape=%s", tostring(df.tiletype.attrs[55].shape)))
print(string.format("  z93 (94,100): tiletype=56, shape=%s", tostring(df.tiletype.attrs[56].shape)))
-- Try tiletype 57
print(string.format("  tiletype 57: shape=%s", tostring(df.tiletype.attrs[57].shape)))
-- Try tiletype 54
print(string.format("  tiletype 54: shape=%s", tostring(df.tiletype.attrs[54].shape)))

-- Search for down stair tiletype
for tt = 50, 60 do
    if df.tiletype.attrs[tt].shape == df.tiletype_shape.STAIR_DOWN then
        print(string.format("  Found STAIR_DOWN: tiletype=%d", tt))
    end
end
