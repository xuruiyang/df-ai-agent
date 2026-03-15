local count = 0
for _, block in ipairs(df.global.world.map.map_blocks) do
    for x = 0, 15 do
        for y = 0, 15 do
            if block.designation[x][y].dig ~= 0 then
                block.flags.designated = true
                count = count + 1
                goto next_block
            end
        end
    end
    ::next_block::
end
print("Refreshed " .. count .. " blocks with dig designations")
