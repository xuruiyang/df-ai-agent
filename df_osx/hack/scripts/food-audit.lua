-- Detailed food audit
local food_counts = {}
for _, item in ipairs(df.global.world.items.all) do
    if not item.flags.forbid and not item.flags.dump and not item.flags.rotten then
        local tp = item:getType()
        local tname = df.item_type[tp]
        if tp == df.item_type.MEAT or tp == df.item_type.FISH or
           tp == df.item_type.PLANT or tp == df.item_type.CHEESE or
           tp == df.item_type.FOOD or tp == df.item_type.EGG or
           tp == df.item_type.SEEDS or tp == df.item_type.LEAVES or
           tp == df.item_type.FISH_RAW then
            food_counts[tname] = (food_counts[tname] or 0) + 1
        end
    end
end
print("=== FOOD BREAKDOWN ===")
for name, count in pairs(food_counts) do
    print(string.format("  %s: %d", name, count))
end

-- The fortress overview shows food=800+ but our count shows 31. The overview must count differently.
-- Check total prepared food value
local prepared = 0
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.FOOD then
        prepared = prepared + item.stack_size
    end
end
print(string.format("\nPrepared food stacks: %d", prepared))

-- Check raw food (plants, meat, fish etc)
local raw = 0
for _, item in ipairs(df.global.world.items.all) do
    if not item.flags.rotten and not item.flags.forbid then
        local tp = item:getType()
        if tp == df.item_type.PLANT then raw = raw + 1 end
    end
end
print(string.format("Raw plants: %d", raw))
