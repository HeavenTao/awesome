local base = require("wibox.widget.base")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("catppuccin.mocha")
local log = require("utils.log")

local timer = { mt = {} }

local week = { "星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六" }

local function new(args)
    local widget = base.make_widget_declarative {
        markup = "<span color='" .. theme.text.hex .. "'>" .. "</span>",
        widget = wibox.widget.textbox
    };

    gears.table.crush(widget, timer, true)

    gears.timer {
        timeout = 10,
        call_now = true,
        autostart = true,
        callback = function()
            local date = os.date("*t")
            local text = string.format("%d-%02d-%02d %02d:%02d  %s", date.year, date.month, date.day, date.hour, date
                .min,
                week[date.wday])
            widget.markup = "<span color='" .. theme.text.hex .. "'>" .. text .. "</span>"
        end
    }
    return widget
end

function timer.mt:__call(...)
    return new(...)
end

return setmetatable(timer, timer.mt)
