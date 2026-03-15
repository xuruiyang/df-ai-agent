-- === STEP 1: ASSIGN LABORS ===
-- Enable hauling + construction on ALL dwarves
local all_ids = {18792, 18793, 18794, 18795, 18796, 18797, 18798}
local haul_labors = {"HAUL_STONE", "HAUL_WOOD", "HAUL_FOOD", "HAUL_ITEM", "HAUL_FURNITURE", "BUILD_CONSTRUCTION"}
for _, uid in ipairs(all_ids) do
    local u = df.unit.find(uid)
    if u then
        for _, lab in ipairs(haul_labors) do
            u.status.labors[df.unit_labor[lab]] = true
        end
    end
end
print("Hauling enabled on all dwarves")

-- Specialist labors
local function set_labor(uid, labor, val)
    local u = df.unit.find(uid)
    if u then u.status.labors[df.unit_labor[labor]] = val end
end

-- 18792 = Miner (already has mining)
set_labor(18792, "MINE", true)

-- 18793 = expedition leader -> brewer/planter/mason
set_labor(18793, "BREWER", true)
set_labor(18793, "PLANT", true)
set_labor(18793, "MASON", true)
set_labor(18793, "CARPENTER", true)

-- 18794 = Jeweler -> crafts + mason
set_labor(18794, "MASON", true)
set_labor(18794, "CARPENTER", true)
set_labor(18794, "STONE_CRAFT", true)
set_labor(18794, "BREWER", true)
set_labor(18794, "PLANT", true)

-- 18795 = Woodworker -> carpenter + brewer
set_labor(18795, "CARPENTER", true)
set_labor(18795, "CUTWOOD", true)
set_labor(18795, "BREWER", true)
set_labor(18795, "PLANT", true)

-- 18796 = Fish Cleaner -> butcher/tanner/brewer/plant
set_labor(18796, "BUTCHER", true)
set_labor(18796, "TANNER", true)
set_labor(18796, "BREWER", true)
set_labor(18796, "PLANT", true)
set_labor(18796, "MASON", true)
set_labor(18796, "CARPENTER", true)

-- 18797 = Woodcutter -> woodcutting + brewing + planting
set_labor(18797, "CUTWOOD", true)
set_labor(18797, "BREWER", true)
set_labor(18797, "PLANT", true)
set_labor(18797, "COOK", true)
set_labor(18797, "HERBALIST", true)

-- 18798 = Fisherdwarf -> disable fishing, enable useful stuff
set_labor(18798, "FISH", false)
set_labor(18798, "BREWER", true)
set_labor(18798, "PLANT", true)
set_labor(18798, "MASON", true)
set_labor(18798, "CARPENTER", true)
set_labor(18798, "HERBALIST", true)

print("All labors assigned")

-- === STEP 2: FIND WAGON AND DIG ENTRANCE ===
-- Wagon should be near (89-91, 100-102, z97) based on last game
-- Find clear floor tile NOT under wagon for entrance
local wagon_x, wagon_y = 89, 100
local entrance_x, entrance_y, entrance_z = 93, 100, 97

-- Verify tile
local block = dfhack.maps.getTileBlock(entrance_x, entrance_y, entrance_z)
if block then
    local lx = entrance_x % 16
    local ly = entrance_y % 16
    local tt = block.tiletype[lx][ly]
    local attrs = df.tiletype.attrs[tt]
    local shape = df.tiletype_shape[attrs.shape] or "?"
    local mat = df.tiletype_material[attrs.material] or "?"
    print(string.format("Entrance tile (%d,%d,%d): shape=%s mat=%s", 
        entrance_x, entrance_y, entrance_z, shape, mat))
    
    -- If it's a shrub or tree, try adjacent tiles
    if mat == "PLANT" or mat == "TREE" then
        -- Try (94,100)
        entrance_x = 94
        block = dfhack.maps.getTileBlock(entrance_x, entrance_y, entrance_z)
        lx = entrance_x % 16
    end
    
    -- Set down stair designation
    block.designation[lx][ly].dig = df.tile_dig_designation.DownStair
    block.flags.designated = true
    print(string.format("Designated entrance at (%d,%d,%d)", entrance_x, entrance_y, entrance_z))
end

-- === STEP 3: DIG-NOW THE ENTRANCE ===
dfhack.run_command("dig-now")
print("Entrance stair dug")

-- === STEP 4: DIG Z96 FORTRESS ===
-- Set up/down stair at z96
local b96 = dfhack.maps.getTileBlock(entrance_x, entrance_y, 96)
if b96 then
    b96.designation[entrance_x%16][entrance_y%16].dig = df.tile_dig_designation.UpDownStair
    b96.flags.designated = true
end

-- Main corridor east-west (3 wide)
for cx = entrance_x - 10, entrance_x + 8 do
    for cy = entrance_y - 1, entrance_y + 1 do
        if cx ~= entrance_x or cy ~= entrance_y then
            local b = dfhack.maps.getTileBlock(cx, cy, 96)
            if b then
                b.designation[cx%16][cy%16].dig = df.tile_dig_designation.Default
                b.flags.designated = true
            end
        end
    end
end

-- Workshop area south (11x11)
local ws_x = entrance_x - 4
local ws_y = entrance_y + 3
for cx = ws_x, ws_x + 10 do
    for cy = ws_y, ws_y + 10 do
        local b = dfhack.maps.getTileBlock(cx, cy, 96)
        if b then
            b.designation[cx%16][cy%16].dig = df.tile_dig_designation.Default
            b.flags.designated = true
        end
    end
end

-- Farm area north (10x10)
local farm_x = entrance_x - 5
local farm_y = entrance_y - 12
for cx = farm_x, farm_x + 9 do
    for cy = farm_y, farm_y + 9 do
        local b = dfhack.maps.getTileBlock(cx, cy, 96)
        if b then
            b.designation[cx%16][cy%16].dig = df.tile_dig_designation.Default
            b.flags.designated = true
        end
    end
end

-- Bedroom wing east (hallway + 7 rooms)
local bed_hallway_x = entrance_x + 9
for cy = entrance_y - 3, entrance_y + 3 do
    local b = dfhack.maps.getTileBlock(bed_hallway_x, cy, 96)
    if b then
        b.designation[bed_hallway_x%16][cy%16].dig = df.tile_dig_designation.Default
        b.flags.designated = true
    end
end
for i = -3, 3 do
    for cx = bed_hallway_x + 1, bed_hallway_x + 3 do
        local b = dfhack.maps.getTileBlock(cx, entrance_y + i, 96)
        if b then
            b.designation[cx%16][(entrance_y + i)%16].dig = df.tile_dig_designation.Default
            b.flags.designated = true
        end
    end
end

-- Connections from corridor to areas
for cy = entrance_y + 1, ws_y do
    local b = dfhack.maps.getTileBlock(entrance_x, cy, 96)
    if b then b.designation[entrance_x%16][cy%16].dig = df.tile_dig_designation.Default; b.flags.designated = true end
end
for cy = farm_y + 9, entrance_y - 1 do
    local b = dfhack.maps.getTileBlock(entrance_x, cy, 96)
    if b then b.designation[entrance_x%16][cy%16].dig = df.tile_dig_designation.Default; b.flags.designated = true end
end

-- DIG-NOW everything on z96
dfhack.run_command("dig-now")
print("Z96 fortress dug")

-- Fix the z96 stairway (dig-now may leave it as floor instead of stair)
local stair96 = dfhack.maps.getTileBlock(entrance_x, entrance_y, 96)
if stair96 then
    local tt = stair96.tiletype[entrance_x%16][entrance_y%16]
    local shape = df.tiletype_shape[df.tiletype.attrs[tt].shape] or "?"
    if shape ~= "STAIR_UPDOWN" then
        -- Find correct tiletype
        local mat = df.tiletype_material[df.tiletype.attrs[tt].material] or "?"
        for i = 0, 600 do
            local a = df.tiletype.attrs[i]
            if a and df.tiletype_shape[a.shape] == "STAIR_UPDOWN" and
               df.tiletype_material[a.material] == mat then
                stair96.tiletype[entrance_x%16][entrance_y%16] = i
                print("Fixed z96 stairway to STAIR_UPDOWN")
                break
            end
        end
    end
end

print(string.format("\n=== STARTUP COMPLETE === Entrance at (%d,%d)", entrance_x, entrance_y))
