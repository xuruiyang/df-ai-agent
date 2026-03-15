-- Check metalworking progress
print("=== FURNACES ===")
for _, bld in ipairs(df.global.world.buildings.all) do
    if df.building_furnacest:is_instance(bld) and bld.flags.exists then
        print(string.format("  %s at (%d,%d,z%d) jobs=%d", df.furnace_type[bld.type], bld.centerx, bld.centery, bld.z, #bld.jobs))
    end
end

-- Count charcoal/coke bars
local charcoal = 0
local gold_bars = 0
local other_bars = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BAR and not item.flags.forbid then
        local mat = dfhack.matinfo.decode(item)
        if mat then
            if mat.type == 0 then  -- inorganic
                if mat.inorganic.id == "GOLD" then
                    gold_bars = gold_bars + item.stack_size
                else
                    other_bars = other_bars + item.stack_size
                end
            else
                -- Check for charcoal (plant-based)
                charcoal = charcoal + item.stack_size
            end
        end
    end
end
print(string.format("\nCharcoal: %d", charcoal))
print(string.format("Gold bars: %d", gold_bars))
print(string.format("Other bars: %d", other_bars))
