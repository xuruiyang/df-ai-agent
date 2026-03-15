-- Spring Year 66 actions: brew, trade, crafts
-- NOTE: Do NOT use dfhack.job.removeJob - it crashes the bridge

-- Helper: add job to workshop
local function add_job(bld, job_type, mat_specs, reaction)
    local job = df.job:new()
    job.job_type = df.job_type[job_type]
    if reaction then job.reaction_name = reaction end
    job.pos = xyz2pos(bld.centerx, bld.centery, bld.z)
    for _, spec in ipairs(mat_specs) do
        local ji = df.job_item:new()
        ji.item_type = spec.item_type
        ji.quantity = spec.quantity
        ji.vector_id = spec.vector_id
        if spec.flags2 then
            for k, v in pairs(spec.flags2) do ji.flags2[k] = v end
        end
        ji.reaction_class = ""
        ji.has_material_reaction_product = ""
        job.job_items:insert('#', ji)
    end
    dfhack.job.linkIntoWorld(job)
    bld.jobs:insert('#', job)
    job.general_refs:insert('#', {new=df.general_ref_building_holderst, building_id=bld.id})
end

local BREW = {
    {item_type=df.item_type.PLANT, quantity=1, vector_id=df.job_item_vector_id.ANY_COOKABLE},
    {item_type=df.item_type.BARREL, quantity=1, vector_id=df.job_item_vector_id.BARREL},
}
local STONE = {{item_type=df.item_type.BOULDER, quantity=1, vector_id=df.job_item_vector_id.BOULDER, flags2={building_material=true, non_economic=true}}}

-- 1. Queue brew jobs on all stills (5 each)
local stills_queued = 0
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) and bld.type == df.workshop_type.Still then
        if #bld.jobs < 5 then
            local to_add = 5 - #bld.jobs
            for i = 1, to_add do
                add_job(bld, "CustomReaction", BREW, "BREW_DRINK_FROM_PLANT")
                stills_queued = stills_queued + 1
            end
        end
    end
end
print(string.format("Queued %d brew jobs across stills", stills_queued))

-- 2. Queue stone crafts at Craftsdwarfs workshop (for trading)
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) and bld.type == df.workshop_type.Craftsdwarfs then
        if #bld.jobs < 15 then
            local to_add = 15 - #bld.jobs
            for i = 1, to_add do
                add_job(bld, "MakeCrafts", STONE)
            end
            print(string.format("Queued %d stone craft jobs", to_add))
        end
    end
end

-- 3. Request trader at depot
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.TradeDepot then
        bld.trade_flags.trader_requested = true
        print("Trader requested at depot")
    end
end

print("Actions complete")
