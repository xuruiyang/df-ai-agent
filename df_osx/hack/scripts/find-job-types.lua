for i = 0, df.job_type._last_item do
    local name = df.job_type[i]
    if name and name:lower():find("brew") then
        print(i .. ": " .. name)
    end
end
-- Also check CustomReaction type names
print("\nChecking for brewing reactions:")
for i = 0, df.job_type._last_item do
    local name = df.job_type[i]
    if name and (name == "CustomReaction" or name:lower():find("custom")) then
        print(i .. ": " .. name)
    end
end
