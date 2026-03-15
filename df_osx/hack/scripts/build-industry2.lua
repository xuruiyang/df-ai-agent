-- Build Metalsmith's Forge (Workshop) and Wood Furnace on z94
local z = 94

local function get_boulder()
    for _, item in ipairs(df.global.world.items.all) do
        if item:getType() == df.item_type.BOULDER
           and not item.flags.in_building
           and not item.flags.forbid
           and not item.flags.in_job
           and not item.flags.construction then
            return item
        end
    end
    return nil
end

-- Build Metalsmith's Forge (Workshop, not Furnace)
local stone = get_boulder()
if stone then
    local forge = dfhack.buildings.allocInstance(
        {x=85, y=95, z=z},
        df.building_type.Workshop, df.workshop_type.MetalsmithsForge, -1)
    if forge then
        forge.x1 = 84; forge.x2 = 86
        forge.y1 = 94; forge.y2 = 96
        forge.centerx = 85; forge.centery = 95
        if dfhack.buildings.constructWithItems(forge, {stone}) then
            print("Metalsmith's Forge placed at (84,94,z94)")
        else
            print("Failed to construct forge")
        end
    end
else
    print("No boulders for forge")
end

-- Build Wood Furnace
stone = get_boulder()
if stone then
    local wf = dfhack.buildings.allocInstance(
        {x=89, y=91, z=z},
        df.building_type.Furnace, df.furnace_type.WoodFurnace, -1)
    if wf then
        wf.x1 = 88; wf.x2 = 90
        wf.y1 = 90; wf.y2 = 92
        wf.centerx = 89; wf.centery = 91
        if dfhack.buildings.constructWithItems(wf, {stone}) then
            print("Wood Furnace placed at (88,90,z94)")
        else
            print("Failed to construct wood furnace")
        end
    end
else
    print("No boulders for wood furnace")
end
