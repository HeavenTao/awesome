local base = require("wibox.widget.base")
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local log = require("utils.log")
local common = require("utils.common")
local theme = require("catppuccin.mocha")
local beautiful = require("beautiful")

local meminfo = { mt = {} }

local delay = 1

function meminfo:updateText(rate)
    local text = common.build_markup(math.ceil(rate) .. "%", theme.green.hex)
    self.markup = common.build_markup("Mem:", theme.text.hex) .. text
end

function meminfo:start()
    gears.timer({
        timeout = delay,
        call_now = true,
        autostart = true,
        callback = function()
            awful.spawn.easy_async("free", function(lines)
                if lines == nil then
                    return nil
                end

                local tmp = {}

                for line in lines:gmatch("[^\n]+") do
                    table.insert(tmp, line)
                end

                local numbers = {}
                for v in string.gmatch(tmp[2], "%d+") do
                    table.insert(numbers, tonumber(v))
                end


                if numbers == nil then
                    return nil
                end

                local total = numbers[1]
                local free = numbers[3]

                local rate = (1 - (free) / total) * 100
                self:updateText(rate)
            end)
        end
    })
end

local function new(args)
    local widget = base.make_widget_declarative({
        widget = wibox.widget.textbox,
        font = beautiful.font .. " 12",
        forced_width = 80
    })

    gears.table.crush(widget, meminfo, true)

    widget:start()

    return widget
end

function meminfo.mt:__call(...)
    return new(...)
end

return setmetatable(meminfo, meminfo.mt)
