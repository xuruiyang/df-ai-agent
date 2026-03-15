-- Fix barrel shortage: build 3rd carpenter workshop dedicated to barrels
-- First check wood supply
local wood = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.WOOD and not item.flags.in_building and not item.flags.forbid and not item.flags.in_job then
        wood = wood + 1
    end
end
print(string.format("Available wood: %d", wood))

-- Build 3rd Carpenters workshop on z93 near stone
local pos = xyz2pos(84, 88, 93)
local bld = dfhack.buildings.allocInstance(pos, df.building_type.Workshop, df.workshop_type.Carpenters, -1)
if not bld then
    print("Failed to allocate Carpenters workshop!")
    return
end
bld.x1 = 83; bld.x2 = 85
bld.y1 = 87; bld.y2 = 89
bld.centerx = 84; bld.centery = 88

-- Find a log to build it with
local log = nil
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.WOOD and not item.flags.in_building and not item.flags.forbid and not item.flags.in_job then
        log = item
        break
    end
end

if not log then
    print("No wood available for workshop construction!")
    return
end

local ok, err = pcall(function()
    dfhack.buildings.constructWithItems(bld, {log})
end)
if ok then
    print(string.format("Built 3rd Carpenters at (84,88,z93) for barrel production"))
    
    -- Queue 30 barrels
    local WOOD = {{item_type=df.item_type.WOOD, quantity=1, vector_id=df.job_item_vector_id.WOOD}}
    for i = 1, 30 do
        local job = df.job:new()
        job.job_type = df.job_type.MakeBarrel
        job.pos = xyz2pos(bld.centerx, bld.centery, bld.z)
        local ji = df.job_item:new()
        ji.item_type = df.item_type.WOOD
        ji.quantity = 1
        ji.vector_id = df.job_item_vector_id.WOOD
        ji.reaction_class = ""
        ji.has_material_reaction_product = ""
        job.job_items:insert('#', ji)
        dfhack.job.linkIntoWorld(job)
        bld.jobs:insert('#', job)
        job.general_refs:insert('#', {new=df.general_ref_building_holderst, building_id=bld.id})
    end
    print("Queued 30 barrels at new workshop")
else
    print("Build failed: " .. tostring(err))
end

-- Also enable CARPENTER labor on more dwarves
local carpenters = 0
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit) and unit.mood < 0 then
        if unit.status.labors[df.unit_labor.CARPENTER] then
            carpenters = carpenters + 1
        end
    end
end
print(string.format("Current carpenters: %d", carpenters))

if carpenters < 6 then
    local needed = 6 - carpenters
    local added = 0
    for _, unit in ipairs(df.global.world.units.active) do
        if dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit) and unit.mood < 0 then
            if not unit.status.labors[df.unit_labor.CARPENTER] then
                unit.status.labors[df.unit_labor.CARPENTER] = true
                added = added + 1
                if added >= needed then break end
            end
        end
    end
    print(string.format("Enabled CARPENTER on %d more dwarves", added))
end
