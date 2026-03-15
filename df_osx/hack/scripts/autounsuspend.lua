-- automate periodic running of the unsuspend script
--[====[

autounsuspend
=============
Periodically check construction jobs and keep them unsuspended with the
`unsuspend` script.
]====]

local repeatUtil = require 'repeat-util'

local job_name = '__autounsuspend'

local function help()
    print('syntax: autounsuspend [start|stop]')
end

local function stop()
    repeatUtil.cancel(job_name)
    print('autounsuspend Stopped.')
end

local function start()
    local unsuspend_fn = function() dfhack.run_script('unsuspend') end
    repeatUtil.scheduleEvery(job_name, '1', 'days', unsuspend_fn)
    print('autounsuspend Running.')
end

local action_switch = {
    start=start,
    stop=stop,
}
setmetatable(action_switch, {__index=function() return help end})

local args = {...}
action_switch[args[1] or 'help']()
