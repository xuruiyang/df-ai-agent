-- Check what stone types we have
local counts = {}
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BOULDER and not item.flags.in_building and not item.flags.forbid and not item.flags.in_job then
        local mat = dfhack.matinfo.decode(item)
        if mat then
            local name = mat.inorganic.id
            counts[name] = (counts[name] or 0) + 1
        end
    end
end

-- Sort and print
local sorted = {}
for name, count in pairs(counts) do
    table.insert(sorted, {name=name, count=count})
end
table.sort(sorted, function(a,b) return a.count > b.count end)

print("=== STONE TYPES (free boulders) ===")
for _, entry in ipairs(sorted) do
    print(string.format("  %s: %d", entry.name, entry.count))
end

-- Check if any are flagged as building material
print("\n=== CHECKING non_economic FLAG ===")
local non_econ = 0
local econ = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.BOULDER and not item.flags.in_building and not item.flags.forbid and not item.flags.in_job then
        local mat = dfhack.matinfo.decode(item)
        if mat then
            -- Check economic flags
            local is_econ = false
            local flags = mat.inorganic.economic_uses
            -- Actually check the inorganic flags for IS_STONE and SEDIMENTARY etc
            if mat.inorganic.flags.ITE_STONE then
                non_econ = non_econ + 1
            else
                econ = econ + 1
            end
        end
    end
end
print(string.format("  STONE flagged: %d, Other: %d", non_econ, econ))
