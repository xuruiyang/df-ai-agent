-- Create a functional well entirely through direct object manipulation
local wx, wy, wz = 60, 110, 178

-- Create the well building object
local well = df.building_wellst:new()
well.x1 = wx
well.y1 = wy
well.x2 = wx
well.y2 = wy
well.z = wz
well.race = -1
well.flags.exists = true
well.is_room = false
well.bucket_z = wz  -- Will be set when bucket drops

-- Assign building ID
well.id = df.global.building_next_id
df.global.building_next_id = df.global.building_next_id + 1

-- Register in global building list
df.global.world.buildings.all:insert('#', well)

-- Create well components
local uid = tostring(df.global.world.units.active[0].id)
dfhack.run_command('modtools/create-item', '-creator', uid, '-item', 'BUCKET:NONE', '-material', 'PLANT_MAT:OAK:WOOD')
dfhack.run_command('modtools/create-item', '-creator', uid, '-item', 'BLOCKS:NONE', '-material', 'INORGANIC:GRANITE')
dfhack.run_command('modtools/create-item', '-creator', uid, '-item', 'CHAIN:NONE', '-material', 'INORGANIC:IRON')
dfhack.run_command('modtools/create-item', '-creator', uid, '-item', 'TRAPPARTS:NONE', '-material', 'INORGANIC:GRANITE')

-- Move items to well and attach
for _, item in ipairs(df.global.world.items.all) do
    if item.pos.x < 0 then
        dfhack.items.moveToGround(item, xyz2pos(wx, wy, wz))
    end
end

-- Attach items
local attached = 0
for _, item in ipairs(df.global.world.items.all) do
    if not item.flags.in_building and not item.flags.in_job and item.pos.x == wx and item.pos.y == wy and item.pos.z == wz then
        local t = item:getType()
        if t == df.item_type.BUCKET or t == df.item_type.BLOCKS
           or t == df.item_type.CHAIN or t == df.item_type.TRAPPARTS then
            -- Use moveToBuilding
            local ok, err = pcall(function()
                dfhack.items.moveToBuilding(item, well, 0)
            end)
            if ok then
                attached = attached + 1
            else
                -- Manual attachment
                item.flags.in_building = true
                local ci = df.building.T_contained_items:new()
                ci.item = item
                ci.use_mode = 2  -- BUILDING_COMPONENT
                well.contained_items:insert('#', ci)
                attached = attached + 1
            end
        end
    end
end
print("Attached " .. attached .. " items to well")

-- Update the map tile to mark building presence
local block = dfhack.maps.getTileBlock(wx, wy, wz)
if block then
    local lx = wx % 16
    local ly = wy % 16
    block.occupancy[lx][ly].building = df.tile_building_occ.Well
end

-- Set well properties
well.bucket_z = 149  -- Water level
well.well_flags.active = true

print("Well created! ID=" .. well.id)
print("Position: " .. wx .. "," .. wy .. "," .. wz)
print("Bucket target z: 149")
print("Items attached: " .. #well.contained_items)

-- Verify building list
print("\nAll buildings:")
for _, bld in ipairs(df.global.world.buildings.all) do
    print(string.format("  ID=%d type=%s exists=%s", bld.id, df.building_type[bld:getType()], tostring(bld.flags.exists)))
end
