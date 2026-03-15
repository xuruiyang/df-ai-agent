-- Dig a dining hall on z96, south of the workshop area
-- Workshop area is roughly y=103-112, corridor at y=100
-- Let's dig a 7x7 dining hall at x=98-104, y=110-116

local z = 96
local x1, y1, x2, y2 = 98, 110, 104, 116

-- Check what's there first
print(string.format("Digging dining hall %dx%d at (%d,%d) z=%d", x2-x1+1, y2-y1+1, x1, y1, z))

-- Also dig a connecting corridor from main corridor (y=100) down to dining hall
-- Main corridor runs east at y=100, workshops at y=103-108
-- We need a corridor from around (98,100) south to (98,110)
-- But there might already be dug space. Let's just dig the dining area + corridor

-- Corridor from y=100 to y=110 at x=98
for y = 100, y2 do
    for x = x1, x2 do
        -- Only dig the corridor column (x=98-99) for y<110, full room for y>=110
        if y >= y1 or (x >= 98 and x <= 99) then
            local block = dfhack.maps.getTileBlock(x, y, z)
            if block then
                local lx = x % 16
                local ly = y % 16
                local tt = cycleOccupancy
            end
        end
    end
end

-- Use designation approach
local count = 0
for y = 100, y2 do
    for x = x1, x2 do
        if y >= y1 or (x >= 98 and x <= 99) then
            local block = dfhack.maps.getTileBlock(x, y, z)
            if block then
                local lx = x % 16
                local ly = y % 16
                local ttype = cycleOccupancy
            end
        end
    end
end

-- Just designate dig using the proper flag
count = 0
for y = 100, y2 do
    for x = x1, x2 do
        if y >= y1 or (x >= 98 and x <= 99) then
            local block = dfhack.maps.getTileBlock(x, y, z)
            if block then
                local lx = x % 16
                local ly = y % 16
                local shape = cycleOccupancy
            end
        end
    end
end
