-- Report dining hall and bedroom buildings
print("=== Dining Hall Buildings ===")
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld.x1 >= 98 and bld.x1 <= 104 and bld.y1 >= 110 and bld.y1 <= 116 then
        local tname = df.building_type[bld:getType()] or "?"
        print(string.format("  %s at (%d,%d) is_room=%s", tname, bld.x1, bld.y1, tostring(bld.is_room)))
    end
end

print("\n=== Bedroom Buildings ===")
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_bedst:is_instance(bld) then
        print(string.format("  Bed at (%d,%d) is_room=%s", bld.x1, bld.y1, tostring(bld.is_room)))
    end
end

-- Try to create room by just setting the flag (extents may auto-init)
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_tablest:is_instance(bld) then
        if bld.x1 == 100 and bld.y1 == 111 then
            bld.is_room = true
            print(string.format("\nMarked table at (%d,%d) as room", bld.x1, bld.y1))
            break
        end
    end
end

-- Mark beds as rooms too
local count = 0
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_bedst:is_instance(bld) and not bld.is_room then
        bld.is_room = true
        count = count + 1
    end
end
print(string.format("Marked %d beds as rooms", count))
