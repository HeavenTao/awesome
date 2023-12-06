local wibox = require("wibox")
local gears = require("gears")
local theme = require("main.theme")
local awful = require("awful")


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

gears.timer {
    timeout = 1,
    call_now = true,
    autostart = true,
    callback = function()
        awful.spawn.easy_async({ "sh", "-c", "date '+%Y-%m-%d %H:%M'" }, function(out)
            textbox.markup = "<span color='" .. theme.text .. "'>" .. out .. "</span>"
        end)
    end
}

return widget
