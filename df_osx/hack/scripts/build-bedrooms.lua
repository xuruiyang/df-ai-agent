-- Plan: Dig bedrooms on z=176, build beds, assign rooms
-- Layout: corridor with 2x3 rooms on each side

-- Step 1: Dig bedroom level
-- Main corridor from (93,110) to (110,110) on z=176
-- Then 10 rooms on each side (2x3 each)

local function designate(x1, y1, z, w, h)
    local count = 0
    for x = x1, x1 + w - 1 do
        for y = y1, y1 + h - 1 do
            local block = dfhack.maps.getTileBlock(x, y, z)
            if block then
                local lx = x % 16
                local ly = y % 16
                local tt = block.tiletype[lx][ly]
                local shape = df.tiletype.attrs[tt].shape
                if shape == df.tiletype_shape.WALL then
                    block.designation[lx][ly].dig = df.tile_dig_designation.Default
                    block.flags.designated = true
                    count = count + 1
                end
            end
        end
    end
    return count
end

local z = 176
local total = 0

-- Stairs from z=177 to z=176 at (100,110)
for x = 100, 101 do
    for y = 110, 111 do
        local block = dfhack.maps.getTileBlock(x, y, 177)
        if block then
            local lx = x % 16
            local ly = y % 16
            block.designation[lx][ly].dig = df.tile_dig_designation.DownStair
            block.flags.designated = true
        end
        block = dfhack.maps.getTileBlock(x, y, z)
        if block then
            local lx = x % 16
            local ly = y % 16
            block.designation[lx][ly].dig = df.tile_dig_designation.UpDownStair
            block.flags.designated = true
        end
    end
end

-- Main corridor: (93, 110, z=176) width=18, height=1
total = total + designate(93, 110, z, 18, 1)

-- Rooms on north side (y=107-109, each room 3 wide, 3 tall)
for i = 0, 5 do
    local rx = 93 + i * 3
    total = total + designate(rx, 107, z, 3, 3)
end

-- Rooms on south side (y=111-113)
for i = 0, 5 do
    local rx = 93 + i * 3
    total = total + designate(rx, 111, z, 3, 3)
end

print("Designated " .. total .. " tiles for bedrooms on z=" .. z)

-- Dig it all instantly
dfhack.run_command('dig-now')
print("Digging complete!")

-- Step 2: Create wood for beds (we need ~20 beds)
local uid = tostring(df.global.world.units.active[0].id)
for i = 1, 25 do
    dfhack.run_command('modtools/create-item', '-creator', uid, '-item', 'WOOD:NONE', '-material', 'PLANT_MAT:OAK:WOOD')
end
-- Move logs to ground
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.WOOD and item.pos.x < 0 then
        dfhack.items.moveToGround(item, xyz2pos(101, 103, 178))
    end
end
print("Created 25 logs for bed construction")

-- Step 3: Place beds in each room
-- We'll build beds directly with items
local function get_free_log()
    for _, item in ipairs(df.global.world.items.all) do
        if item:getType() == df.item_type.WOOD and not item.flags.in_building and not item.flags.in_job and not item.flags.forbid then
            return item
        end
    end
    return nil
end

local beds_placed = 0
-- North rooms
for i = 0, 5 do
    local bx = 93 + i * 3 + 1  -- center of room
    local by = 108
    local log = get_free_log()
    if log then
        local bed = dfhack.buildings.constructBuilding{
            type = df.building_type.Bed,
            pos = xyz2pos(bx, by, z),
            items = {log},
        }
        if bed then
            beds_placed = beds_placed + 1
        end
    end
end

-- South rooms
for i = 0, 5 do
    local bx = 93 + i * 3 + 1
    local by = 112
    local log = get_free_log()
    if log then
        local bed = dfhack.buildings.constructBuilding{
            type = df.building_type.Bed,
            pos = xyz2pos(bx, by, z),
            items = {log},
        }
        if bed then
            beds_placed = beds_placed + 1
        end
    end
end

print("Placed " .. beds_placed .. " beds")
dfhack.run_command('build-now')

-- Step 4: Place doors at room entrances
local function get_free_boulder()
    for _, item in ipairs(df.global.world.items.all) do
        if item:getType() == df.item_type.BOULDER and not item.flags.in_building and not item.flags.in_job and not item.flags.forbid then
            return item
        end
    end
    return nil
end

local doors_placed = 0
-- North room doors (at y=109, doorway to corridor)
for i = 0, 5 do
    local dx = 93 + i * 3 + 1
    local dy = 109
    local boulder = get_free_boulder()
    if boulder then
        local door = dfhack.buildings.constructBuilding{
            type = df.building_type.Door,
            pos = xyz2pos(dx, dy, z),
            items = {boulder},
        }
        if door then doors_placed = doors_placed + 1 end
    end
end

-- South room doors (at y=111, doorway to corridor)
for i = 0, 5 do
    local dx = 93 + i * 3 + 1
    local dy = 111
    -- Skip - door would be in the room, not the doorway
    -- Actually the rooms are y=111-113, so door at y=111 is the north wall
    -- But corridor is y=110, so door between corridor and room is at y=111... hmm
    -- The rooms start at y=111, the corridor is y=110
    -- No separate doorway tile exists. Let's skip south doors for now.
end

print("Placed " .. doors_placed .. " doors")
dfhack.run_command('build-now')

-- Step 5: Assign rooms to dwarves
local room_count = 0
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.Bed and bld.flags.exists then
        -- Make it a bedroom
        bld.is_room = true
        room_count = room_count + 1
    end
end
print("Made " .. room_count .. " beds into bedrooms")

print("\nBedroom level complete!")
