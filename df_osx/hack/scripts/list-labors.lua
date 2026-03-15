local t = {}
for i = 0, df.unit_labor._last_item do
    local name = df.unit_labor[i]
    if name then
        table.insert(t, name)
    end
end
for _, v in ipairs(t) do
    print(v)
end
