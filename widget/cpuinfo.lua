local base = require("wibox.widget.base")
local wibox = require("wibox")
local gears = require("gears")
local log = require("utils.log")

local cpuinfo = { mt = {} }

local delay = 1

function cpuinfo:getCpuInfo()
    local lines = io.open("/proc/stat", "r")
    if lines == nil then
        return ""
    end

    local first_line = lines:read("*l")

    io.close()
end

function cpuinfo:stat()

end

function cpuinfo:updateText()

end

function cpuinfo:start()
    gears.timer({
        timeout = delay,
        call_now = true,
        autostart = true,
        callback = function()
            self:getCpuInfo()
        end
    })
end

local function new(args)
    local widget = base.make_widget_declarative({
        widget = wibox.widget.textbox
    })

    gears.table.crush(widget, cpuinfo, true)

    widget:start()

    return widget
end

function cpuinfo.mt:__call(...)
    return new(...)
end

return setmetatable(cpuinfo, cpuinfo.mt)
