local wibox = require("wibox")
local gears = require("gears")
local theme = require("main.theme")

local function timer()
    local week = { "星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六" }

    local textbox = wibox.widget {
        markup = "<span color='" .. theme.text .. "'>" .. "</span>",
        widget = wibox.widget.textbox
    };


    local widget = wibox.widget {
        {
            widget = wibox.container.margin,
            left = 10,
            right = 10,
            textbox
        },
        bg = theme.bg,
        shape_border_width = 2,
        shape_border_color = theme.border,
        widget = wibox.container.background,
        shape = gears.shape.rounded_bar
    }

    widget:connect_signal("mouse::enter", function()
        widget.shape_border_color = theme.border_active
    end)

    widget:connect_signal("mouse::leave", function()
        widget.shape_border_color = theme.border
    end)

    gears.timer {
        timeout = 10,
        call_now = true,
        autostart = true,
        callback = function()
            local date = os.date("*t")
            local text = string.format("%d-%02d-%02d %02d:%02d  %s", date.year, date.month, date.day, date.hour, date
                .min,
                week[date.wday])
            textbox.markup = "<span color='" .. theme.text .. "'>" .. text .. "</span>"
        end
    }

    return widget
end

return timer
