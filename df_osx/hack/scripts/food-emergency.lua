-- Emergency food production
-- 1. Enable HERBALIST on several dwarves for plant gathering
-- 2. Enable HUNT on someone
-- 3. Enable BUTCHER, COOK on someone
-- 4. Set farm plots to grow plump helmets
-- 5. Build a Kitchen

local function enable_labor(unit_id, labor_name)
    local unit = df.unit.find(unit_id)
    if unit then
        local labor = df.unit_labor[labor_name]
        if labor then
            unit.status.labors[labor] = true
        end
    end
end

-- Enable plant gathering on several dwarves
local gather_dwarves = {5087, 5089, 5238, 5239, 5243}
for _, uid in ipairs(gather_dwarves) do
    enable_labor(uid, "HERBALIST")
    enable_labor(uid, "PLANT")
end

-- Enable hunting
enable_labor(5244, "HUNT")  -- Weaponsmith has weapons

-- Enable butchering and cooking
enable_labor(5089, "BUTCHER")
enable_labor(5089, "COOK")
enable_labor(5353, "COOK")

-- Build a Kitchen workshop
local kitchen = dfhack.buildings.constructBuilding{
    type = df.building_type.Workshop,
    subtype = df.workshop_type.Kitchen,
    pos = xyz2pos(113, 98, 178),
    width = 3,
    height = 3,
}
if kitchen then
    -- Try to find a boulder for it
    for _, item in ipairs(df.global.world.items.all) do
        if item:getType() == df.item_type.BOULDER
           and not item.flags.in_building
           and not item.flags.forbid
           and not item.flags.in_job then
            local ok = dfhack.buildings.constructBuilding{
                type = df.building_type.Workshop,
                subtype = df.workshop_type.Kitchen,
                pos = xyz2pos(113, 98, 178),
                width = 3,
                height = 3,
                items = {item},
            }
            -- Actually, we already have it queued, need to add material
            break
        end
    end
    print("Kitchen queued, ID=" .. kitchen.id)
    dfhack.run_command('build-now')
else
    print("Kitchen placement failed, trying another spot")
    -- Try building in the underground area
    local k2 = dfhack.buildings.constructBuilding{
        type = df.building_type.Workshop,
        subtype = df.workshop_type.Kitchen,
        pos = xyz2pos(95, 109, 177),
        width = 3,
        height = 3,
    }
    if k2 then
        print("Kitchen placed underground, ID=" .. k2.id)
        dfhack.run_command('build-now')
    end
end

-- Build a Butcher shop
local butcher = dfhack.buildings.constructBuilding{
    type = df.building_type.Workshop,
    subtype = df.workshop_type.Butchers,
    pos = xyz2pos(99, 109, 177),
    width = 3,
    height = 3,
}
if butcher then
    print("Butcher shop placed, ID=" .. butcher.id)
    dfhack.run_command('build-now')
end

-- Also chop some trees urgently
enable_labor(5090, "CUTWOOD")
enable_labor(5356, "CUTWOOD")

print("Emergency food measures activated!")
print("Dwarves should now gather plants, hunt, and farm.")
