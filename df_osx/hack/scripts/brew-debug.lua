-- Debug brewing: check still workers
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) and bld.type == df.workshop_type.Still and bld.flags.exists then
        print(string.format("Still at (%d,%d,z%d) jobs=%d", bld.centerx, bld.centery, bld.z, #bld.jobs))
        for i, job in ipairs(bld.jobs) do
            local worker = "none"
            for _, ref in ipairs(job.general_refs) do
                if df.general_ref_unit_workerst:is_instance(ref) then
                    local u = df.unit.find(ref.unit_id)
                    if u then worker = dfhack.TranslateName(dfhack.units.getVisibleName(u)) end
                end
            end
            print(string.format("  Job %d: type=%s worker=%s", i, tostring(job.job_type), worker))
            if i >= 2 then break end
        end
    end
end
