-- List available building construction methods
for k, v in pairs(dfhack.buildings) do
    if type(v) == "function" then
        print(string.format("  dfhack.buildings.%s = %s", k, type(v)))
    end
end
