-- Set up a meeting hall / guildhall from existing dining room
-- Find the dining hall tables and mark one as a meeting hall

-- Check current zones
print("=== ACTIVITY ZONES ===")
local zone_count = 0
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.Civzone then
        zone_count = zone_count + 1
    end
end
print(string.format("Existing zones: %d", zone_count))

-- Find tables (for dining room / meeting hall)
print("\n=== TABLES ===")
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.Table and bld.flags.exists then
        print(string.format("  Table at (%d,%d,z%d) id=%d is_room=%s",
            bld.x1, bld.y1, bld.z, bld.id, tostring(bld.is_room)))
    end
end

-- Make a table into a dining room if not already
local found_room = false
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.Table and bld.flags.exists then
        if not bld.is_room then
            bld.is_room = true
            print(string.format("\nMade table id=%d into a room (dining/meeting hall)", bld.id))
            found_room = true
            break
        else
            print(string.format("\nTable id=%d already a room", bld.id))
            found_room = true
            break
        end
    end
end

if not found_room then
    print("No tables found for guildhall!")
end
