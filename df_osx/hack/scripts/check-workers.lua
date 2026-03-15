-- Check who has BURN_WOOD and SMELT labors
local burn_wood = 0
local smelt = 0
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit) and unit.mood < 0 then
        if unit.status.labors[df.unit_labor.BURN_WOOD] then burn_wood = burn_wood + 1 end
        if unit.status.labors[df.unit_labor.SMELT] then smelt = smelt + 1 end
    end
end
print(string.format("BURN_WOOD laborers: %d", burn_wood))
print(string.format("SMELT laborers: %d", smelt))

-- Check wood furnace first job status
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_furnacest:is_instance(bld) and bld.type == df.furnace_type.WoodFurnace and bld.flags.exists then
        for i, job in ipairs(bld.jobs) do
            print(string.format("  Job %d: type=%s items=%d", i, tostring(job.job_type), #job.job_items))
            if i > 1 then break end
        end
    end
end
