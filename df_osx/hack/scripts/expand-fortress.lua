-- Expand fortress for 42 dwarves
-- Need ~20 more bedrooms, more furniture, more food production

-- 1. Dig bedroom space on z95 (currently 20x20 storage)
-- Put bedrooms along corridors on z95
print("=== DIGGING BEDROOMS on z95 ===")
local designated = 0

-- Dig a corridor + bedroom area on z95
-- Corridor: x=95, y=80-110
for y = 80, 110 do
    local block = dfhack.maps.getTileBlock(95, y, 95)
    if block then
        local lx = 95 % 16
        local ly = y % 16
        local tt = block.tiletype[lx][ly]
        local shape = df.tiletype.attrs[tt].shape
        if shape == df.tiletype_shape.WALL then
            block.designation[lx][ly].dig = df.tile_dig_designation.Default
            block.flags.designated = true
            designated = designated + 1
        end
    end
end

-- Bedrooms: 2x2 rooms branching off the corridor
-- East side: rooms at x=96-97, every 3 tiles of y
for room = 0, 9 do
    local ry = 81 + room * 3
    for x = 96, 97 do
        for y = ry, ry + 1 do
            local block = dfhack.maps.getTileBlock(x, y, 95)
            if block then
                local lx = x % 16
                local ly = y % 16
                local tt = block.tiletype[lx][ly]
                local shape = df.tiletype.attrs[tt].shape
                if shape == df.tiletype_shape.WALL then
                    block.designation[lx][ly].dig = df.tile_dig_designation.Default
                    block.flags.designated = true
                    designated = designated + 1
                end
            end
        end
    end
end

-- West side: rooms at x=93-94, every 3 tiles of y
for room = 0, 9 do
    local ry = 81 + room * 3
    for x = 93, 94 do
        for y = ry, ry + 1 do
            local block = dfhack.maps.getTileBlock(x, y, 95)
            if block then
                local lx = x % 16
                local ly = y % 16
                local tt = block.tiletype[lx][ly]
                local shape = df.tiletype.attrs[tt].shape
                if shape == df.tiletype_shape.WALL then
                    block.designation[lx][ly].dig = df.tile_dig_designation.Default
                    block.flags.designated = true
                    designated = designated + 1
                end
            end
        end
    end
end

print(string.format("  Designated %d tiles for bedrooms on z95", designated))

-- 2. Queue furniture at mason workshop
local function add_job(bld, job_type, mat_specs)
    local job = df.job:new()
    job.job_type = df.job_type[job_type]
    job.pos = xyz2pos(bld.centerx, bld.centery, bld.z)
    for _, spec in ipairs(mat_specs) do
        local ji = df.job_item:new()
        ji.item_type = spec.item_type
        ji.quantity = spec.quantity
        ji.vector_id = spec.vector_id
        if spec.flags2 then
            for k, v in pairs(spec.flags2) do ji.flags2[k] = v end
        end
        ji.reaction_class = ""
        ji.has_material_reaction_product = ""
        job.job_items:insert('#', ji)
    end
    dfhack.job.linkIntoWorld(job)
    bld.jobs:insert('#', job)
    job.general_refs:insert('#', {new=df.general_ref_building_holderst, building_id=bld.id})
end

local WOOD = {{item_type=df.item_type.WOOD, quantity=1, vector_id=df.job_item_vector_id.WOOD}}
local STONE = {{item_type=df.item_type.BOULDER, quantity=1, vector_id=df.job_item_vector_id.BOULDER, flags2={building_material=true, non_economic=true}}}

-- Queue beds at carpenter (need 20)
print("\n=== QUEUING FURNITURE ===")
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) and bld.type == df.workshop_type.Carpenters then
        -- Only add to workshop with fewer jobs
        if #bld.jobs < 20 then
            for i = 1, 20 do
                add_job(bld, "ConstructBed", WOOD)
            end
            print(string.format("  Queued 20 beds at Carpenters (%d,%d)", bld.centerx, bld.centery))
            break
        end
    end
end

-- Queue doors at mason (need 20)
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) and bld.type == df.workshop_type.Masons then
        for i = 1, 20 do
            add_job(bld, "ConstructDoor", STONE)
        end
        -- Also queue 10 tables and 10 chairs for expanded dining
        for i = 1, 10 do
            add_job(bld, "ConstructTable", STONE)
        end
        for i = 1, 10 do
            add_job(bld, "ConstructThrone", STONE)
        end
        -- Queue 10 coffins for cemetery
        for i = 1, 5 do
            add_job(bld, "ConstructCoffin", STONE)
        end
        print(string.format("  Queued 20 doors, 10 tables, 10 chairs, 5 coffins at Mason"))
        break
    end
end

-- 3. Scale up brewing - queue more barrel production
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) and bld.type == df.workshop_type.Carpenters then
        if bld.centerx == 93 then  -- 2nd carpenter on z94
            for i = 1, 15 do
                add_job(bld, "MakeBarrel", WOOD)
            end
            print("  Queued 15 barrels at 2nd Carpenters")
            break
        end
    end
end

print("\nExpansion orders placed!")
