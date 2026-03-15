local bs = df.global.world.buildings.all
print("Total buildings: " .. #bs)
for i = 0, #bs - 1 do
    local b = bs[i]
    local btype = df.building_type[b:getType()]
    local constructed = b.flags.exists
    local jobs_count = #b.jobs
    print(string.format("  ID=%d type=%s pos=(%d,%d,%d) exists=%s jobs=%d",
        b.id, tostring(btype), b.x1, b.y1, b.z,
        tostring(constructed), jobs_count))
end
