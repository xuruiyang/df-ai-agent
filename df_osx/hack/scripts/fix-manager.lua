-- Inspect manager orders
local orders = df.global.world.manager_orders

print("Manager orders: " .. #orders)
for i = 0, #orders - 1 do
    local order = orders[i]
    local jt = df.job_type[order.job_type]
    local active = order.status.active
    local validated = order.status.validated
    print(string.format("  Order %d: %s qty=%d active=%s validated=%s",
        i, jt, order.amount_left, tostring(active), tostring(validated)))

    -- Force validate
    order.status.validated = true
    order.status.active = true
end
print("Orders force-validated and activated!")

-- Check workshop jobs
print("\nWorkshop jobs:")
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.Workshop then
        print(string.format("  Workshop %d jobs=%d", bld.id, #bld.jobs))
    end
end

-- Count world jobs
local count = 0
local link = df.global.world.jobs.list.next
while link do
    count = count + 1
    link = link.next
end
print("Total jobs in world: " .. count)
