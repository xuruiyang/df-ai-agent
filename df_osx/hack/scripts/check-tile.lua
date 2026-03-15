-- Check tile details at the entrance dig point
local x, y, z = 90, 100, 97
local block = dfhack.maps.getTileBlock(x, y, z)
if block then
    local lx = x % 16
    local ly = y % 16
    local tt = block.tiletype[lx][ly]
    local attrs = df.tiletype.attrs[tt]
    print(string.format("Tile at (%d,%d,%d):", x, y, z))
    print(string.format("  tiletype=%d", tt))
    print(string.format("  shape=%s", tostring(attrs.shape)))
    print(string.format("  material=%s", tostring(attrs.material)))
    print(string.format("  special=%s", tostring(attrs.special)))
    local desig = block.designation[lx][ly]
    print(string.format("  hidden=%s", tostring(desig.hidden)))
    print(string.format("  dig=%d", desig.dig))
    print(string.format("  outside=%s", tostring(desig.outside)))
    print(string.format("  subterranean=%s", tostring(desig.subterranean_water)))
    print(string.format("  light=%s", tostring(desig.light)))
end

-- Also check pathability - is Sigun able to reach?
print("\nChecking Sigun position and pathing:")
local unit = df.unit.find(18792)
if unit then
    print(string.format("  Sigun at (%d,%d,%d)", unit.pos.x, unit.pos.y, unit.pos.z))
end

-- Check z96 tile
local x2, y2, z2 = 90, 100, 96
block = dfhack.maps.getTileBlock(x2, y2, z2)
if block then
    local lx = x2 % 16
    local ly = y2 % 16
    local tt = block.tiletype[lx][ly]
    local attrs = df.tiletype.attrs[tt]
    local desig = block.designation[lx][ly]
    print(string.format("\nTile at (%d,%d,%d):", x2, y2, z2))
    print(string.format("  tiletype=%d shape=%s material=%s", tt, tostring(attrs.shape), tostring(attrs.material)))
    print(string.format("  hidden=%s dig=%d", tostring(desig.hidden), desig.dig))
end
