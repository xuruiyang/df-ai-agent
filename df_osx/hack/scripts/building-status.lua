-- Check all non-existing buildings
print("=== BUILDINGS UNDER CONSTRUCTION ===")
local under_construction = 0
for _, bld in ipairs(df.global.world.buildings.all) do
    if not bld.flags.exists then
        under_construction = under_construction + 1
    end
end
print(string.format("Buildings still under construction: %d", under_construction))

-- Check specific buildings
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) or df.building_furnacest:is_instance(bld) then
        if not bld.flags.exists then
            local name = "?"
            if df.building_workshopst:is_instance(bld) then name = df.workshop_type[bld.type]
            elseif df.building_furnacest:is_instance(bld) then name = df.furnace_type[bld.type]
            end
            print(string.format("  %s at (%d,%d,z%d) — not built", name, bld.centerx, bld.centery, bld.z))
        end
    end
end

-- Check craft production
local crafts = 0
local craft_types = {}
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.CRAFTS and not item.flags.in_building and not item.flags.forbid then
        crafts = crafts + 1
    end
end
print(string.format("\nTotal crafts: %d (including in-job)", crafts))

-- Check z94 access
print("\n=== z94 WORKSHOP ACCESS ===")
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_workshopst:is_instance(bld) and bld.type == df.workshop_type.Still then
        if bld.z == 94 then
            print(string.format("Still at (89,95,z94) exists=%s jobs=%d", tostring(bld.flags.exists), #bld.jobs))
        end
    end
end
