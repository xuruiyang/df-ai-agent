-- Check charcoal job details and fix if needed
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_furnacest:is_instance(bld) and bld.type == df.furnace_type.WoodFurnace and bld.flags.exists then
        print(string.format("WoodFurnace (%d,%d,z%d) jobs=%d", bld.centerx, bld.centery, bld.z, #bld.jobs))
        for i, job in ipairs(bld.jobs) do
            print(string.format("  Job %d: type=%s (%d) reaction='%s' items=%d",
                i, tostring(job.job_type), job.job_type, job.reaction_name, #job.job_items))
            for j, ji in ipairs(job.job_items) do
                print(string.format("    Item %d: type=%s qty=%d vector=%s",
                    j, tostring(ji.item_type), ji.quantity, tostring(ji.vector_id)))
            end
            if i >= 2 then break end
        end
    end
end

-- Check correct job type for charcoal
-- In DF, MakeCharcoal = specific job type 
print("\n=== JOB TYPE LOOKUP ===")
for i = 200, 220 do
    local name = df.job_type[i]
    if name and (name:lower():find("char") or name:lower():find("smelt") or name:lower():find("ash")) then
        print(string.format("  %d = %s", i, name))
    end
end

-- Look for MakeCharcoal
local mc = df.job_type.MakeCharcoal
if mc then print(string.format("MakeCharcoal = %d", mc)) end
