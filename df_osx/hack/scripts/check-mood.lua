for _, unit in ipairs(df.global.world.units.active) do
    if unit.mood >= 0 then
        local name = dfhack.TranslateName(dfhack.units.getVisibleName(unit))
        local mood_name = df.mood_type[unit.mood] or "?"
        print(string.format("Moody dwarf: %s - mood=%s", name, mood_name))
        -- Check what workshop they claimed
        if unit.job.current_job then
            print(string.format("  Current job: %s",
                df.job_type[unit.job.current_job.job_type] or "?"))
        end
    end
end
