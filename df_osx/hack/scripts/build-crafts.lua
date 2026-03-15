-- Build craftsdwarf's workshop at various locations until one works
local function get_free_boulder()
    for _, item in ipairs(df.global.world.items.all) do
        if item:getType() == df.item_type.BOULDER and not item.flags.in_building and not item.flags.in_job then
            return item
        end
    end
    return nil
end

local positions = {
    {96, 114, 177},
    {100, 114, 177},
    {104, 114, 177},
    {108, 114, 177},
    {93, 107, 177},
    {97, 107, 177},
    {109, 98, 178},  -- surface fallback
}

for _, pos in ipairs(positions) do
    local boulder = get_free_boulder()
    if not boulder then print("No boulders!"); return end

    local w = dfhack.buildings.constructBuilding{
        type = df.building_type.Workshop,
        subtype = df.workshop_type.Craftsdwarfs,
        pos = xyz2pos(pos[1], pos[2], pos[3]),
        width = 3,
        height = 3,
        items = {boulder},
    }
    if w then
        print("Craftsdwarf's workshop at " .. pos[1] .. "," .. pos[2] .. "," .. pos[3] .. " ID=" .. w.id)
        dfhack.run_command('build-now')
        return
    end
end
print("Could not place craftsdwarf's workshop anywhere!")
