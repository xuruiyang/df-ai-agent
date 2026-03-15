-- Set designation and run dig-now with proper coordinate format
local x, y, z = 92, 100, 97
local block = dfhack.maps.getTileBlock(x, y, z)
local lx = x % 16
local ly = y % 16
block.designation[lx][ly].dig = df.tile_dig_designation.DownStair
block.flags.designated = true

-- dig-now expects --start x,y,z --end x,y,z or just runs on all designations
dfhack.run_command("dig-now")
print("dig-now executed for all designations")

-- Check result at entrance
local tt = block.tiletype[lx][ly]
local attrs = df.tiletype.attrs[tt]
print(string.format("(%d,%d,%d): shape=%s mat=%s tiletype=%d", x, y, z,
    tostring(df.tiletype_shape[attrs.shape]),
    tostring(df.tiletype_material[attrs.material]),
    tt))
