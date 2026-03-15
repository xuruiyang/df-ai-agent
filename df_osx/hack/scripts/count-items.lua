-- Count all craft-like items
local counts = {}
for _, item in ipairs(df.global.world.items.all) do
    if not item.flags.forbid and not item.flags.dump then
        local tp = item:getType()
        if tp == df.item_type.CRAFTS or tp == df.item_type.AMULET or
           tp == df.item_type.BRACELET or tp == df.item_type.CROWN or
           tp == df.item_type.RING or tp == df.item_type.FIGURINE or
           tp == df.item_type.EARRING or tp == df.item_type.SCEPTER or
           tp == df.item_type.GEM then
            local name = df.item_type[tp]
            counts[name] = (counts[name] or 0) + 1
        end
    end
end

print("=== CRAFT ITEMS ===")
local total = 0
for name, count in pairs(counts) do
    print(string.format("  %s: %d", name, count))
    total = total + count
end
print(string.format("  TOTAL: %d", total))

-- Check if CRAFTS specifically means something different
print("\n=== ALL item_type.CRAFTS ===")
local craft_count = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.CRAFTS then
        craft_count = craft_count + 1
        if craft_count <= 5 then
            print(string.format("  id=%d flags: in_bld=%s forbid=%s job=%s",
                item.id, tostring(item.flags.in_building), tostring(item.flags.forbid), tostring(item.flags.in_job)))
        end
    end
end
print(string.format("Total CRAFTS items: %d", craft_count))
