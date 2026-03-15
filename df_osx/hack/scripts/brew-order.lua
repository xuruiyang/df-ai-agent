-- Find the Still and check if it's constructed
local still = nil
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.Workshop then
        local ws = bld:getSubtype()
        if df.workshop_type[ws] == "Still" then
            still = bld
            print(string.format("Found Still id=%d constructed=%s", bld.id, tostring(bld.flags.exists)))
            break
        end
    end
end

if not still then
    print("No Still found!")
    return
end

if not still.flags.exists then
    print("Still not yet constructed - waiting...")
    return
end

-- Try to add a brewing manager order using correct approach
-- In DF, brewing uses "CustomReaction" with reaction_name "BREW_DRINK" or just "Drink"
-- Let's try adding it via manager orders
local order = df.manager_order:new()
order.job_type = df.job_type.CustomReaction
order.reaction_name = "BREW_DRINK"
order.amount_left = 10
order.amount_total = 10
order.id = df.global.world.manager_order_next_id
df.global.world.manager_order_next_id = df.global.world.manager_order_next_id + 1
df.global.world.manager_orders:insert('#', order)
print("Added brewing manager order id=" .. order.id)
