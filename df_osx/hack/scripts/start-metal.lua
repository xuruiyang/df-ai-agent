-- Start metalworking: charcoal + smelting
local function add_job(bld, job_type, mat_specs, reaction)
    local job = df.job:new()
    job.job_type = df.job_type[job_type]
    if reaction then job.reaction_name = reaction end
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

-- Find wood furnace and queue charcoal
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_furnacest:is_instance(bld) and bld.type == df.furnace_type.WoodFurnace and bld.flags.exists then
        print(string.format("Wood Furnace at (%d,%d,z%d) jobs=%d", bld.centerx, bld.centery, bld.z, #bld.jobs))
        if #bld.jobs < 5 then
            for i = 1, 5 do
                add_job(bld, "CustomReaction", WOOD, "CHARCOAL_MAKING")
            end
            print("Queued 5 charcoal jobs")
        end
    end
end

-- Find smelter and queue smelting (native gold -> gold bars)
-- Cinnabar -> mercury (but mercury isn't useful for much)
-- Let's try smelting native gold ore into gold bars
local FUEL_AND_ORE = {
    {item_type=df.item_type.BAR, quantity=1, vector_id=df.job_item_vector_id.BAR, flags2={fire_safe=true}},
    {item_type=df.item_type.BOULDER, quantity=1, vector_id=df.job_item_vector_id.BOULDER},
}

-- Check what ores we have
print("\n=== ORES ===")
local ore_counts = {}
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BOULDER and not item.flags.in_building and not item.flags.forbid and not item.flags.in_job then
        local mat = dfhack.matinfo.decode(item)
        if mat then
            local name = mat.inorganic.id
            if name == "NATIVE_GOLD" or name == "CINNABAR" or name == "NATIVE_SILVER" or
               name == "NATIVE_COPPER" or name == "HEMATITE" or name == "MAGNETITE" or
               name == "LIMONITE" or name == "TETRAHEDRITE" or name == "GALENA" then
                ore_counts[name] = (ore_counts[name] or 0) + 1
            end
        end
    end
end
for name, count in pairs(ore_counts) do
    print(string.format("  %s: %d", name, count))
end

-- Queue gold smelting if we have native gold
if ore_counts["NATIVE_GOLD"] and ore_counts["NATIVE_GOLD"] > 0 then
    for _, bld in ipairs(df.global.world.buildings.all) do
        if df.building_furnacest:is_instance(bld) and bld.type == df.furnace_type.Smelter and bld.flags.exists then
            print(string.format("\nSmelter at (%d,%d,z%d) jobs=%d", bld.centerx, bld.centery, bld.z, #bld.jobs))
            -- Queue gold smelting
            -- Need charcoal (fuel) first, so this might not work immediately
            -- Use CustomReaction for smelting
            if #bld.jobs < 3 then
                for i = 1, 3 do
                    add_job(bld, "SmeltOre", FUEL_AND_ORE)
                end
                print("Queued 3 smelt ore jobs (need charcoal first)")
            end
        end
    end
end

-- Enable SMELT, FORGE, and BURN_WOOD labors
local labors_to_enable = {
    df.unit_labor.SMELT, df.unit_labor.FORGE_WEAPON, df.unit_labor.FORGE_ARMOR,
    df.unit_labor.BURN_WOOD, df.unit_labor.METAL_CRAFT
}
for _, labor in ipairs(labors_to_enable) do
    local count = 0
    for _, unit in ipairs(df.global.world.units.active) do
        if dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit) and unit.mood < 0 then
            if unit.status.labors[labor] then count = count + 1 end
        end
    end
    if count < 3 then
        local added = 0
        for _, unit in ipairs(df.global.world.units.active) do
            if dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit) and unit.mood < 0 then
                if not unit.status.labors[labor] then
                    unit.status.labors[labor] = true
                    added = added + 1
                    if added >= (3 - count) then break end
                end
            end
        end
    end
end
print("\nEnabled metalworking labors")
