-- Spawn emergency food and drink
local uid = tostring(df.global.world.units.active[0].id)

-- Create plump helmets (brewable + edible)
for i = 1, 30 do
    dfhack.run_command('modtools/create-item', '-creator', uid, '-item', 'PLANT:NONE', '-material', 'PLANT_MAT:MUSHROOM_HELMET_PLUMP:STRUCTURAL')
end
print("Created 30 plump helmets")

-- Create dwarven wine barrels
for i = 1, 30 do
    dfhack.run_command('modtools/create-item', '-creator', uid, '-item', 'DRINK:NONE', '-material', 'PLANT_MAT:MUSHROOM_HELMET_PLUMP:DRINK')
end
print("Created 30 dwarven wine")

print("Emergency supplies spawned!")
