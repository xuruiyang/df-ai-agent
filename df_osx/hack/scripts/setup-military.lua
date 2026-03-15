-- Set up a basic militia squad
local entity = df.global.ui.main.fortress_entity

-- Check existing squads
print("=== Current Military ===")
print(string.format("Squads: %d", #df.global.world.squads.all))
for _, squad in ipairs(df.global.world.squads.all) do
    print(string.format("  Squad: %s (id=%d, members=%d)",
        dfhack.TranslateName(squad.name, true),
        squad.id, #squad.positions))
end

-- Check available weapons
print("\n=== Available Weapons ===")
local weapons = {}
for _, item in ipairs(df.global.world.items.all) do
    if item:getType() == df.item_type.WEAPON
       and not item.flags.in_building
       and not item.flags.forbid then
        local name = dfhack.items.getDescription(item, 0)
        weapons[name] = (weapons[name] or 0) + 1
    end
end
for name, ct in pairs(weapons) do
    print(string.format("  %s: %d", name, ct))
end

-- Check available armor
print("\n=== Available Armor ===")
local armor = {}
for _, item in ipairs(df.global.world.items.all) do
    local tp = item:getType()
    if (tp == df.item_type.ARMOR or tp == df.item_type.HELM or
        tp == df.item_type.GLOVES or tp == df.item_type.SHOES or
        tp == df.item_type.SHIELD or tp == df.item_type.PANTS)
       and not item.flags.in_building and not item.flags.forbid then
        local name = dfhack.items.getDescription(item, 0)
        armor[name] = (armor[name] or 0) + 1
    end
end
for name, ct in pairs(armor) do
    print(string.format("  %s: %d", name, ct))
end
