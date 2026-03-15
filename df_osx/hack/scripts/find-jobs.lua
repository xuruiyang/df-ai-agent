-- Find trade-related labors
for i = 0, 100 do
    local name = df.unit_labor[i]
    if name and (name:lower():find("trade") or name:lower():find("broker")) then
        print(i, name)
    end
end
print("---")
-- Also list all labors that contain certain keywords
for i = 0, 100 do
    local name = df.unit_labor[i]
    if name then
        print(i, name)
    end
end
