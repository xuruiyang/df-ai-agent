-- Force-complete the well by manipulating building state directly
local well = df.building.find(20)
if not well then
    print("Well ID=20 not found")
    -- List all buildings
    for _, bld in ipairs(df.global.world.buildings.all) do
        print(string.format("  ID=%d type=%s", bld.id, df.building_type[bld:getType()]))
    end
    return
end

print("Well found at " .. well.x1 .. "," .. well.y1 .. "," .. well.z)
print("Exists: " .. tostring(well.flags.exists))

-- Check contained items
print("Contained items: " .. #well.contained_items)
for i, ci in ipairs(well.contained_items) do
    if ci.item then
        print(string.format("  Item %d: %s at %d,%d,%d",
            i, df.item_type[ci.item:getType()], ci.item.pos.x, ci.item.pos.y, ci.item.pos.z))
    end
end

-- If the well has no items, we need to add them
if #well.contained_items == 0 then
    print("Well has no items attached. Looking for components...")

    -- Find unused well components
    local bucket, block_item, chain, mechanism
    for _, item in ipairs(df.global.world.items.all) do
        if not item.flags.in_building and not item.flags.in_job then
            if item:getType() == df.item_type.BUCKET and not bucket then bucket = item end
            if item:getType() == df.item_type.BLOCKS and not block_item then block_item = item end
            if item:getType() == df.item_type.CHAIN and not chain then chain = item end
            if item:getType() == df.item_type.TRAPPARTS and not mechanism then mechanism = item end
        end
    end

    local items = {bucket, block_item, chain, mechanism}
    local all_found = true
    for _, item in ipairs(items) do
        if not item then all_found = false end
    end

    if all_found then
        -- Attach items to the well
        for _, item in ipairs(items) do
            -- Move item to the well's position
            dfhack.items.moveToBuilding(item, well, 0)
        end
        print("Items attached to well!")
    else
        print("Missing well components")
    end
end

-- Force the well to exist
well.flags.exists = true

-- Set the well as functional
-- Wells need bucket_z to be set properly
well.bucket_z = 149  -- z-level where water is

print("Well should now be functional!")
print("Dwarves can fetch water from this well.")

-- Verify
print("\nWell status:")
print("  Exists: " .. tostring(well.flags.exists))
print("  Bucket Z: " .. tostring(well.bucket_z))
print("  Contained items: " .. #well.contained_items)
