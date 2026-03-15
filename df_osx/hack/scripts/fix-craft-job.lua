-- Fix the stone craft job on workshop 55
local ws = df.building.find(55)
if not ws then print("Workshop 55 not found!"); return end

print("Workshop 55 info:")
print("  Type: " .. tostring(ws:getType()))
print("  Pos: " .. ws.x1 .. "," .. ws.y1 .. "," .. ws.z)
print("  Jobs: " .. #ws.jobs)

for i = 0, #ws.jobs - 1 do
    local job = ws.jobs[i]
    print("  Job " .. i .. ":")
    print("    type: " .. tostring(job.job_type))
    print("    mat_type: " .. tostring(job.mat_type))
    print("    mat_index: " .. tostring(job.mat_index))
    print("    id: " .. tostring(job.id))
    print("    repeat: " .. tostring(job.flags['repeat']))
    print("    item_type: " .. tostring(job.item_type))
    print("    item_subtype: " .. tostring(job.item_subtype))
    print("    reaction_name: " .. tostring(job.reaction_name))
    print("    refs: " .. #job.general_refs)
    print("    items: " .. #job.items)
end

-- Check if dwarves have the right skill/labor
local crafters = 0
for _, unit in ipairs(df.global.world.units.active) do
    if dfhack.units.isCitizen(unit) and unit.status.labors[df.unit_labor.STONE_CRAFT] then
        crafters = crafters + 1
    end
end
print("\nDwarves with STONE_CRAFT labor: " .. crafters)

-- Check if there are accessible boulders
local boulders = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BOULDER and not item.flags.in_building and not item.flags.in_job and not item.flags.forbid then
        boulders = boulders + 1
    end
end
print("Available boulders: " .. boulders)

-- Try removing existing jobs and adding fresh one
for i = #ws.jobs - 1, 0, -1 do
    dfhack.job.removeJob(ws.jobs[i])
end
print("\nRemoved old jobs")

-- Add new MakeCrafts job with proper setup
local job = df.job:new()
job.job_type = df.job_type.MakeCrafts
job.mat_type = 0  -- INORGANIC
job.mat_index = -1
job.item_type = -1
job.item_subtype = -1
job.pos = xyz2pos(ws.x1 + 1, ws.y1 + 1, ws.z)
job.flags['repeat'] = true

-- Add building reference
local ref = df.general_ref_building_holderst:new()
ref.building_id = ws.id
job.general_refs:insert('#', ref)

-- Link into world
job.id = df.global.job_next_id
df.global.job_next_id = df.global.job_next_id + 1
local link = df.job_list_link:new()
link.item = job
link.prev = df.global.world.jobs.list
link.next = df.global.world.jobs.list.next
if df.global.world.jobs.list.next then
    df.global.world.jobs.list.next.prev = link
end
df.global.world.jobs.list.next = link

ws.jobs:insert('#', job)
print("Added new MakeCrafts job (ID=" .. job.id .. ")")

-- Also try MakeRockCrafts if MakeCrafts doesn't work
-- Actually in DF, the reaction for stone crafts at a Craftsdwarf's Workshop
-- uses job_type = MakeCrafts with specific item_type settings
-- Let's try the 'workflow' or 'order' approach instead
print("\nAlternative: Using manager orders for stone crafts")
local order = df.manager_order:new()
order.id = df.global.world.manager_order_next_id
df.global.world.manager_order_next_id = df.global.world.manager_order_next_id + 1
order.job_type = df.job_type.MakeCrafts
order.mat_type = 0  -- stone/inorganic
order.mat_index = -1
order.item_type = -1
order.item_subtype = -1
order.amount_left = 30
order.amount_total = 30
order.status.validated = true
order.status.active = true
df.global.world.manager_orders:insert('#', order)
print("Added manager order for 30 stone crafts (ID=" .. order.id .. ")")
