-- Clear old designation and re-designate as channel
local x, y, z = 90, 100, 97
local block = dfhack.maps.getTileBlock(x, y, z)
if block then
    block.designation[x % 16][y % 16].dig = df.tile_dig_designation.No
    print("Cleared old designation at surface")
end

-- Use DFHack's digAt which properly creates jobs
-- Actually, let me just try using the dig command properly
dfhack.run_command("dig", "dig")
