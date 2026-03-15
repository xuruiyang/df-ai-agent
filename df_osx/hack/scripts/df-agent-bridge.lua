-- df-agent-bridge: File-based IPC bridge for the df-agent AI assistant
-- Runs inside DFHack, exposes game state and commands via file polling
-- Usage: df-agent-bridge [start|stop|status]

local json = require('json')
local repeatUtil = require('repeat-util')

local BRIDGE_NAME = 'df-agent-bridge'
local IPC_DIR = dfhack.getDFPath() .. '/df-agent-ipc'
local REQUEST_FILE = IPC_DIR .. '/request.json'
local RESPONSE_FILE = IPC_DIR .. '/response.json'
local LOCK_FILE = IPC_DIR .. '/ready.lock'

-- Helpers

local function get_unit_name(unit)
    if not unit then return '?' end
    local visible = dfhack.units.getVisibleName(unit)
    if visible then
        local name = dfhack.TranslateName(visible)
        if name and name ~= '' then return name end
    end
    local race = df.creature_raw.find(unit.race)
    if race then return race.name[0] end
    return '?'
end

local function get_unit_profession_name(unit)
    return dfhack.units.getProfessionName(unit)
end

local function get_unit_job(unit)
    if unit.job.current_job then
        return df.job_type[unit.job.current_job.job_type] or 'Unknown'
    end
    return 'Idle'
end

local function is_citizen(unit)
    return dfhack.units.isCitizen(unit) and dfhack.units.isAlive(unit)
end

local function is_military(unit)
    return unit.military.squad_id >= 0
end

local function get_season_name(tick)
    local month = math.floor(tick / 33600) % 12
    local seasons = {'Early Spring', 'Mid Spring', 'Late Spring',
                     'Early Summer', 'Mid Summer', 'Late Summer',
                     'Early Autumn', 'Mid Autumn', 'Late Autumn',
                     'Early Winter', 'Mid Winter', 'Late Winter'}
    return seasons[month + 1] or 'Unknown'
end

-- Handler implementations

local handlers = {}

function handlers.ping()
    return {status = 'ok', bridge = BRIDGE_NAME}
end

function handlers.pause()
    df.global.pause_state = true
    return {paused = true}
end

function handlers.unpause()
    df.global.pause_state = false
    return {paused = false}
end

function handlers.get_pause_state()
    return {paused = df.global.pause_state}
end

function handlers.get_game_time()
    local tick = df.global.cur_year_tick
    local year = df.global.cur_year
    return {
        year = year,
        tick = tick,
        season = get_season_name(tick),
        paused = df.global.pause_state,
    }
end

function handlers.get_fortress_overview()
    local total_citizens = 0
    for _, unit in ipairs(df.global.world.units.active) do
        if is_citizen(unit) then
            total_citizens = total_citizens + 1
        end
    end

    local food_count = 0
    local drink_count = 0
    for _, item in ipairs(df.global.world.items.other.ANY_GOOD_FOOD) do
        if not item.flags.rotten and not item.flags.forbid and dfhack.items.getGeneralRef(item, df.general_ref_type.CONTAINED_IN_ITEM) == nil then
            food_count = food_count + 1
        end
    end
    for _, item in ipairs(df.global.world.items.other.DRINK) do
        if not item.flags.rotten and not item.flags.forbid then
            local stack = 1
            if item.stack_size then stack = item.stack_size end
            drink_count = drink_count + stack
        end
    end

    local announcements = {}
    local ann_list = df.global.world.status.announcements
    local start_idx = math.max(0, #ann_list - 10)
    for i = start_idx, #ann_list - 1 do
        local ann = ann_list[i]
        if ann then
            table.insert(announcements, {
                text = ann.text,
                year = ann.year,
                tick = ann.time,
            })
        end
    end

    local tick = df.global.cur_year_tick
    return {
        population = total_citizens,
        year = df.global.cur_year,
        season = get_season_name(tick),
        tick = tick,
        food = food_count,
        drink = drink_count,
        paused = df.global.pause_state,
        announcements = announcements,
    }
end

function handlers.get_units(params)
    params = params or {}
    local filter = params.filter or 'citizens'
    local limit = params.limit or 50
    local results = {}

    for _, unit in ipairs(df.global.world.units.active) do
        if #results >= limit then break end

        local citizen = dfhack.units.isCitizen(unit)
        local alive = dfhack.units.isAlive(unit)
        local dominated = dfhack.units.isOwnCiv(unit)
        local dominated_group = dfhack.units.isOwnGroup(unit)
        local animal = dominated and not citizen and unit.race ~= df.global.ui.race_id
        local include = false

        if filter == 'citizens' then
            include = citizen and alive
        elseif filter == 'military' then
            include = citizen and alive and is_military(unit)
        elseif filter == 'animals' then
            include = dominated and animal and alive
        elseif filter == 'all' then
            include = dominated and alive
        elseif filter == 'visitors' then
            include = not citizen and not animal and dominated_group and alive
        end

        if include then
            table.insert(results, {
                id = unit.id,
                name = get_unit_name(unit),
                profession = get_unit_profession_name(unit),
                job = get_unit_job(unit),
                pos = {x = unit.pos.x, y = unit.pos.y, z = unit.pos.z},
                squad_id = unit.military.squad_id,
            })
        end
    end
    return {units = results, count = #results}
end

function handlers.get_unit_detail(params)
    if not params or not params.id then error('unit id required') end
    local unit = df.unit.find(params.id)
    if not unit then error('unit not found: ' .. tostring(params.id)) end

    local skills = {}
    if unit.status and unit.status.current_soul then
        for _, skill in ipairs(unit.status.current_soul.skills) do
            table.insert(skills, {
                id = df.job_skill[skill.id] or tostring(skill.id),
                rating = skill.rating,
                experience = skill.experience,
            })
        end
    end

    local labors = {}
    for i = 0, df.unit_labor._last_item do
        if unit.status.labors[i] then
            local name = df.unit_labor[i]
            if name then table.insert(labors, name) end
        end
    end

    return {
        id = unit.id,
        name = get_unit_name(unit),
        profession = get_unit_profession_name(unit),
        job = get_unit_job(unit),
        pos = {x = unit.pos.x, y = unit.pos.y, z = unit.pos.z},
        squad_id = unit.military.squad_id,
        skills = skills,
        labors = labors,
    }
end

function handlers.get_buildings(params)
    params = params or {}
    local type_filter = params.type
    local limit = params.limit or 50
    local results = {}

    for _, bld in ipairs(df.global.world.buildings.all) do
        if #results >= limit then break end
        local btype = df.building_type[bld:getType()] or 'Unknown'
        if not type_filter or btype == type_filter then
            local entry = {
                id = bld.id,
                type = btype,
                pos = {x = bld.x1, y = bld.y1, z = bld.z},
                size = {w = bld.x2 - bld.x1 + 1, h = bld.y2 - bld.y1 + 1},
            }
            if bld:getType() == df.building_type.Workshop then
                local name = df.workshop_type[bld:getSubtype()]
                if name then entry.subtype = name end
            elseif bld:getType() == df.building_type.Furnace then
                local name = df.furnace_type[bld:getSubtype()]
                if name then entry.subtype = name end
            end
            table.insert(results, entry)
        end
    end
    return {buildings = results, count = #results}
end

function handlers.get_resources()
    local counts = {}
    local categories = {
        {name = 'food', list = 'ANY_GOOD_FOOD'},
        {name = 'drink', list = 'DRINK'},
        {name = 'wood', list = 'WOOD'},
        {name = 'stone', list = 'BOULDER'},
        {name = 'bar', list = 'BAR'},
        {name = 'cloth', list = 'CLOTH'},
        {name = 'leather', list = 'SKIN_TANNED'},
        {name = 'weapon', list = 'WEAPON'},
        {name = 'armor', list = 'ARMOR'},
        {name = 'ammo', list = 'AMMO'},
    }
    for _, cat in ipairs(categories) do
        local list = df.global.world.items.other[cat.list]
        if list then
            local count = 0
            for _, item in ipairs(list) do
                if not item.flags.rotten and not item.flags.forbid and not item.flags.dump and not item.flags.trader then
                    count = count + 1
                end
            end
            counts[cat.name] = count
        else
            counts[cat.name] = 0
        end
    end
    return counts
end

function handlers.get_manager_orders()
    local orders = {}
    for _, order in ipairs(df.global.world.manager_orders) do
        table.insert(orders, {
            id = order.id,
            job_type = df.job_type[order.job_type] or 'Unknown',
            amount_left = order.amount_left,
            amount_total = order.amount_total,
            is_active = order.status.active,
        })
    end
    return {orders = orders, count = #orders}
end

function handlers.get_workshops(params)
    params = params or {}
    local limit = params.limit or 50
    local results = {}
    for _, bld in ipairs(df.global.world.buildings.all) do
        if #results >= limit then break end
        if bld:getType() == df.building_type.Workshop or bld:getType() == df.building_type.Furnace then
            local btype
            if bld:getType() == df.building_type.Workshop then
                btype = df.workshop_type[bld:getSubtype()] or 'CustomWorkshop'
            else
                btype = df.furnace_type[bld:getSubtype()] or 'CustomFurnace'
            end
            local jobs = {}
            for _, job in ipairs(bld.jobs) do
                table.insert(jobs, {
                    type = df.job_type[job.job_type] or 'Unknown',
                    items_needed = #job.job_items,
                })
            end
            table.insert(results, {
                id = bld.id, type = btype,
                pos = {x = bld.x1, y = bld.y1, z = bld.z},
                jobs = jobs,
            })
        end
    end
    return {workshops = results, count = #results}
end

function handlers.get_military()
    local squads = {}
    for _, squad in ipairs(df.global.world.squads.all) do
        local members = {}
        for _, pos in ipairs(squad.positions) do
            if pos.occupant >= 0 then
                local fig = df.historical_figure.find(pos.occupant)
                if fig then
                    local unit = df.unit.find(fig.unit_id)
                    if unit then
                        table.insert(members, {id = unit.id, name = get_unit_name(unit)})
                    end
                end
            end
        end
        table.insert(squads, {
            id = squad.id,
            name = dfhack.TranslateName(squad.name),
            member_count = #members,
            members = members,
        })
    end
    return {squads = squads, count = #squads}
end

function handlers.get_announcements(params)
    params = params or {}
    local limit = params.limit or 20
    local results = {}
    local ann_list = df.global.world.status.announcements
    local start_idx = math.max(0, #ann_list - limit)
    for i = start_idx, #ann_list - 1 do
        local ann = ann_list[i]
        if ann then
            table.insert(results, {text = ann.text, year = ann.year, tick = ann.time})
        end
    end
    return {announcements = results, count = #results}
end

function handlers.get_map_area(params)
    if not params then error('params required') end
    local x1 = params.x or 0
    local y1 = params.y or 0
    local z = params.z or 0
    local w = math.min(params.w or 20, 50)
    local h = math.min(params.h or 20, 50)
    local tiles = {}
    for dy = 0, h - 1 do
        local row = {}
        for dx = 0, w - 1 do
            local x = x1 + dx
            local y = y1 + dy
            local tt = dfhack.maps.getTileType(x, y, z)
            local tile_info = {x = x, y = y}
            if tt then
                local shape = df.tiletype.attrs[tt].shape
                local mat = df.tiletype.attrs[tt].material
                tile_info.shape = df.tiletype_shape[shape] or 'NONE'
                tile_info.material = df.tiletype_material[mat] or 'NONE'
            else
                tile_info.shape = 'NONE'
                tile_info.material = 'NONE'
            end
            table.insert(row, tile_info)
        end
        table.insert(tiles, row)
    end
    return {tiles = tiles, z = z, x = x1, y = y1, w = w, h = h}
end

-- Command executors

function handlers.designate_dig(params)
    if not params then error('params required') end
    local x1 = params.x1 or params.x
    local y1 = params.y1 or params.y
    local z = params.z
    local x2 = params.x2 or (x1 + (params.w or 1) - 1)
    local y2 = params.y2 or (y1 + (params.h or 1) - 1)
    local dig_type = params.dig_type or 'Default'
    if not x1 or not y1 or not z then error('coordinates (x, y, z) required') end
    local dig_mode = df.tile_dig_designation[dig_type]
    if not dig_mode then
        error('invalid dig_type: ' .. tostring(dig_type) .. '. Valid: Default, UpDownStair, Channel, Ramp, UpStair, DownStair')
    end
    local count = 0
    for x = x1, x2 do
        for y = y1, y2 do
            local block = dfhack.maps.getTileBlock(x, y, z)
            if block then
                block.designation[x % 16][y % 16].dig = dig_mode
                count = count + 1
            end
        end
    end
    return {designated = count, dig_type = dig_type}
end

function handlers.place_building(params)
    if not params then error('params required') end
    if not params.type or not params.x or not params.y or not params.z then
        error('type, x, y, z required')
    end
    local cmd = string.format('building/create-building %s %d %d %d', params.type, params.x, params.y, params.z)
    local output = dfhack.run_command_silent(cmd)
    return {result = output, type = params.type, pos = {x = params.x, y = params.y, z = params.z}}
end

function handlers.remove_building(params)
    if not params or not params.id then error('building id required') end
    local bld = df.building.find(params.id)
    if not bld then error('building not found: ' .. tostring(params.id)) end
    dfhack.buildings.deconstruct(bld)
    return {removed = params.id}
end

function handlers.assign_labor(params)
    if not params then error('params required') end
    if not params.unit_id or not params.labor then error('unit_id and labor required') end
    local unit = df.unit.find(params.unit_id)
    if not unit then error('unit not found: ' .. tostring(params.unit_id)) end
    local labor_id = df.unit_labor[params.labor]
    if not labor_id then error('invalid labor: ' .. tostring(params.labor)) end
    local enable = params.enable
    if enable == nil then enable = true end
    unit.status.labors[labor_id] = enable
    return {unit_id = params.unit_id, labor = params.labor, enabled = enable}
end

function handlers.add_manager_order(params)
    if not params or not params.job_type then error('job_type required') end
    local job_type = df.job_type[params.job_type]
    if not job_type then error('invalid job_type: ' .. tostring(params.job_type)) end
    local quantity = params.quantity or 1
    local order = df.manager_order:new()
    order.job_type = job_type
    order.amount_left = quantity
    order.amount_total = quantity
    order.id = df.global.world.manager_order_next_id
    df.global.world.manager_order_next_id = df.global.world.manager_order_next_id + 1
    df.global.world.manager_orders:insert('#', order)
    return {order_id = order.id, job_type = params.job_type, quantity = quantity}
end

function handlers.run_dfhack_command(params)
    if not params or not params.command then error('command string required') end
    local output, status = dfhack.run_command_silent(params.command)
    return {output = output or '', status = status}
end

-- Dispatch

local function dispatch(request)
    local method = request.method
    if not method then error('no method specified') end
    local handler = handlers[method]
    if not handler then error('unknown method: ' .. tostring(method)) end
    return handler(request.params)
end

-- File-based IPC

local function ensure_dir()
    if not dfhack.filesystem.isdir(IPC_DIR) then
        dfhack.filesystem.mkdir(IPC_DIR)
    end
end

local function on_tick()
    -- Check if request file exists
    if not dfhack.filesystem.exists(REQUEST_FILE) then
        return
    end

    -- Read request
    local f = io.open(REQUEST_FILE, 'r')
    if not f then return end
    local content = f:read('*all')
    f:close()

    -- Remove request file immediately to signal we're processing
    os.remove(REQUEST_FILE)

    if not content or content == '' then return end

    -- Decode and dispatch
    local ok_decode, request = pcall(json.decode, content)
    local response
    if ok_decode and request then
        local ok_dispatch, result = pcall(dispatch, request)
        if ok_dispatch then
            response = json.encode({id = request.id, result = result}, {pretty = false})
        else
            response = json.encode({id = request.id, error = tostring(result)}, {pretty = false})
        end
    else
        response = json.encode({error = 'invalid JSON'}, {pretty = false})
    end

    -- Write response
    local rf = io.open(RESPONSE_FILE, 'w')
    if rf then
        rf:write(response)
        rf:close()
    end
end

-- Start/stop

local function start_bridge()
    ensure_dir()
    -- Clean up stale files
    os.remove(REQUEST_FILE)
    os.remove(RESPONSE_FILE)
    -- Write lock file to signal bridge is ready
    local lf = io.open(LOCK_FILE, 'w')
    if lf then
        lf:write('ready')
        lf:close()
    end
    repeatUtil.scheduleEvery(BRIDGE_NAME, 1, 'frames', on_tick)
    print(BRIDGE_NAME .. ': started (file IPC at ' .. IPC_DIR .. ')')
end

local function stop_bridge()
    repeatUtil.cancel(BRIDGE_NAME)
    os.remove(REQUEST_FILE)
    os.remove(RESPONSE_FILE)
    os.remove(LOCK_FILE)
    print(BRIDGE_NAME .. ': stopped')
end

local function status_bridge()
    if dfhack.filesystem.exists(LOCK_FILE) then
        print(BRIDGE_NAME .. ': running (IPC dir: ' .. IPC_DIR .. ')')
    else
        print(BRIDGE_NAME .. ': not running')
    end
end

-- Main
local args = {...}
local cmd = args[1] or 'start'

if cmd == 'start' then
    start_bridge()
elseif cmd == 'stop' then
    stop_bridge()
elseif cmd == 'status' then
    status_bridge()
else
    print('Usage: df-agent-bridge [start|stop|status]')
end
