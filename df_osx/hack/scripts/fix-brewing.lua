-- Fix the brewing order reaction name
for i, order in ipairs(df.global.world.manager_orders) do
    if order.reaction_name == "BREW_DRINK" then
        order.reaction_name = "BREW_DRINK_FROM_PLANT"
        print("Fixed brewing order reaction name")
    end
end

-- Check if we need a manager appointed
print("\nNoble positions:")
for _, position in ipairs(df.global.world.entities.all[df.global.ui.civ_id].positions.own) do
    if position.code == "MANAGER" or position.name[0]:lower():find("manager") then
        print(string.format("  Found manager position: '%s' id=%d", position.name[0], position.id))
    end
end

-- Check appointed nobles
print("\nAppointed nobles:")
for _, assignment in ipairs(df.global.world.entities.all[df.global.ui.civ_id].positions.assignments) do
    local pos = nil
    for _, p in ipairs(df.global.world.entities.all[df.global.ui.civ_id].positions.own) do
        if p.id == assignment.position_id then
            pos = p
            break
        end
    end
    if pos then
        local hf_id = assignment.histfig
        local name = "vacant"
        if hf_id >= 0 then
            local hf = df.historical_figure.find(hf_id)
            if hf then
                name = dfhack.TranslateName(hf.name)
            end
        end
        print(string.format("  %s: %s (hf=%d)", pos.name[0], name, hf_id))
    end
end

-- Try to appoint Sigun (expedition leader) as manager too
print("\nAttempting to use workflow or other approach...")

-- Add jobs directly to workshops as alternative
-- Add brewing job to the Still
local still = nil
for _, bld in ipairs(df.global.world.buildings.all) do
    if bld:getType() == df.building_type.Workshop and df.workshop_type[bld:getSubtype()] == "Still" then
        still = bld
        break
    end
end

if still and still.flags.exists then
    print("Adding brew job directly to Still...")
    local job = df.job:new()
    job.job_type = df.job_type.CustomReaction
    job.reaction_name = "BREW_DRINK_FROM_PLANT"
    job.pos.x = still.centerx
    job.pos.y = still.centery
    job.pos.z = still.z
    
    -- Link to the building
    local bref = df.general_ref_building_holderst:new()
    bref.building_id = still.id
    job.general_refs:insert('#', bref)
    
    -- Insert into job list and building
    dfhack.job.linkIntoWorld(job)
    still.jobs:insert('#', job)
    
    print("Brew job added to Still directly!")
end
