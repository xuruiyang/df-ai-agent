-- Debug wood furnace: check job worker assignment
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_furnacest:is_instance(bld) and bld.type == df.furnace_type.WoodFurnace and bld.flags.exists then
        print(string.format("WoodFurnace (%d,%d,z%d) jobs=%d", bld.centerx, bld.centery, bld.z, #bld.jobs))
        for i, job in ipairs(bld.jobs) do
            local worker = "none"
            for _, ref in ipairs(job.general_refs) do
                if df.general_ref_unit_workerst:is_instance(ref) then
                    local u = df.unit.find(ref.unit_id)
                    if u then worker = dfhack.TranslateName(dfhack.units.getVisibleName(u)) end
                end
            end
            print(string.format("  Job %d: type=%s (%d) worker=%s reaction='%s'",
                i, tostring(job.job_type), job.job_type, worker, job.reaction_name))
            if i >= 3 then break end
        end
    end
end

-- Check wood on z94
local wood_z94 = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.WOOD and item.pos.z == 94 and
       not item.flags.in_building and not item.flags.forbid and not item.flags.in_job then
        wood_z94 = wood_z94 + 1
    end
end
print(string.format("\nWood on z94: %d", wood_z94))

-- Check wood nearest to furnace
local wood_close = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.WOOD and not item.flags.in_building and not item.flags.forbid and not item.flags.in_job then
        if math.abs(item.pos.x - 89) + math.abs(item.pos.y - 91) < 20 and item.pos.z >= 94 and item.pos.z <= 97 then
            wood_close = wood_close + 1
        end
    end
end
print(string.format("Wood within 20 tiles of furnace (z94-97): %d", wood_close))
