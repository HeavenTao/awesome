local wibox = require("wibox")
local gears = require("gears")
local theme = require("main.theme")
local awful = require("awful")

local week = {
    Monday = "星期一",
    Tuesday = "星期二",
    Wednesday = "星期三",
    Thursday = "星期四",
    Friday = "星期五",
    Satarday = "星期六",
    Sunday = "星期日"
}

local textbox = wibox.widget {
    markup = "<span color='" .. theme.text .. "'>" .. "</span>",
    widget = wibox.widget.textbox
};

local month_calendar = awful.widget.calendar_popup.month()

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
    timeout = 1,
    call_now = true,
    autostart = true,
    callback = function()
        awful.spawn.easy_async({ "sh", "-c", "date '+%Y-%m-%d %H:%M,%A'" }, function(out)
            local strList = {}
            for value in out:gmatch("[^,]+") do
                table.insert(strList, value)
            end
            --gears.debug.print_error()
            --local weekStr = week[strList[2]];
            --textbox.markup = "<span color='" .. theme.text .. "'>" .. strList[1] .. weekStr .. "</span>"
        end)
    end
}

return widget
