-- Check craftsdwarfs workshop in detail
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) and bld.type == df.workshop_type.Craftsdwarfs then
        print(string.format("Craftsdwarfs at (%d,%d,z%d) jobs=%d", bld.centerx, bld.centery, bld.z, #bld.jobs))
        for i, job in ipairs(bld.jobs) do
            print(string.format("  Job %d: %s items=%d", i, tostring(job.job_type), #job.job_items))
            for j, ji in ipairs(job.job_items) do
                print(string.format("    Item %d: type=%s qty=%d vector=%s",
                    j, tostring(ji.item_type), ji.quantity, tostring(ji.vector_id)))
                print(string.format("    flags2: building_material=%s non_economic=%s",
                    tostring(ji.flags2.building_material), tostring(ji.flags2.non_economic)))
            end
            if i > 2 then print("  ..."); break end
        end
    end
end

-- Check if there are boulders near the workshop (z96)
print("\n=== BOULDERS ON z96 ===")
local z96_count = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BOULDER and item.pos.z == 96 and
       not item.flags.in_building and not item.flags.forbid and not item.flags.in_job then
        z96_count = z96_count + 1
    end
end
print(string.format("  Free boulders on z96: %d", z96_count))

local z95_count = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BOULDER and item.pos.z == 95 and
       not item.flags.in_building and not item.flags.forbid and not item.flags.in_job then
        z95_count = z95_count + 1
    end
end
print(string.format("  Free boulders on z95: %d", z95_count))

local z93_count = 0
local z92_count = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BOULDER and not item.flags.in_building and not item.flags.forbid and not item.flags.in_job then
        if item.pos.z == 93 then z93_count = z93_count + 1 end
        if item.pos.z == 92 then z92_count = z92_count + 1 end
    end
end
print(string.format("  Free boulders on z93: %d", z93_count))
print(string.format("  Free boulders on z92: %d", z92_count))
