for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) and bld.type == df.workshop_type.Craftsdwarfs then
        print(string.format("Craftsdwarfs at (%d,%d,z%d) exists=%s jobs=%d",
            bld.centerx, bld.centery, bld.z, tostring(bld.flags.exists), #bld.jobs))
        if #bld.jobs > 0 then
            local j = bld.jobs[0]
            print(string.format("  First job: %s items_needed=%d", tostring(j.job_type), #j.job_items))
            for k, ji in ipairs(j.job_items) do
                print(string.format("    Item %d: type=%s qty=%d flags2_bm=%s flags2_ne=%s",
                    k, tostring(ji.item_type), ji.quantity,
                    tostring(ji.flags2.building_material), tostring(ji.flags2.non_economic)))
            end
        end
    end
end

-- Are there any granite boulders on z93?
local granite_z93 = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BOULDER and item.pos.z == 93 and
       not item.flags.in_building and not item.flags.forbid and not item.flags.in_job then
        local mat = dfhack.matinfo.decode(item)
        if mat and mat.inorganic.id == "GRANITE" then
            granite_z93 = granite_z93 + 1
        end
    end
end
print(string.format("\nGranite boulders on z93: %d", granite_z93))
