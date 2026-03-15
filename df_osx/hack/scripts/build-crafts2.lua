-- Build a 2nd Craftsdwarfs workshop on z93 where the stone is
local pos = xyz2pos(88, 88, 93)
local bld = dfhack.buildings.allocInstance(pos, df.building_type.Workshop, df.workshop_type.Craftsdwarfs, -1)
if not bld then
    print("Failed to allocate Craftsdwarfs workshop!")
    return
end
bld.x1 = 87; bld.x2 = 89
bld.y1 = 87; bld.y2 = 89
bld.centerx = 88; bld.centery = 88

-- Need a boulder to construct the workshop
local stone = nil
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BOULDER and item.pos.z == 93 and
       not item.flags.in_building and not item.flags.forbid and not item.flags.in_job then
        stone = item
        break
    end
end

if not stone then
    print("No stone found on z93!")
    return
end

local ok, err = pcall(function()
    dfhack.buildings.constructWithItems(bld, {stone})
end)
if ok then
    print(string.format("Built Craftsdwarfs workshop at (88,88,z93) id=%d", bld.id))
else
    print("Build failed: " .. tostring(err))
end

-- Now queue craft jobs at this new workshop
local function add_job(ws, job_type, mat_specs)
    local job = df.job:new()
    job.job_type = df.job_type[job_type]
    job.pos = xyz2pos(ws.centerx, ws.centery, ws.z)
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
    ws.jobs:insert('#', job)
    job.general_refs:insert('#', {new=df.general_ref_building_holderst, building_id=ws.id})
end

local STONE = {{item_type=df.item_type.BOULDER, quantity=1, vector_id=df.job_item_vector_id.BOULDER, flags2={building_material=true, non_economic=true}}}

-- Queue 20 stone crafts
for i = 1, 20 do
    add_job(bld, "MakeCrafts", STONE)
end
print("Queued 20 stone craft jobs at new workshop")
