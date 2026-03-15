for _, bld in ipairs(df.global.world.buildings.all) do
    local btype = df.building_type[bld:getType()] or "?"
    local subtype = ""
    if bld:getType() == df.building_type.Workshop then
        subtype = " (" .. (df.workshop_type[bld:getSubtype()] or "?") .. ")"
    end
    print(string.format("  id=%d %s%s z%d constructed=%s", 
        bld.id, btype, subtype, bld.z, tostring(bld.flags.exists)))
end
