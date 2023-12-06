local wibox = require("wibox")
local gears = require("gears")
local theme = require("main.theme")

local widget = wibox.widget {
    {
        widget = wibox.container.margin,
        left = 10,
        right = 10,
        {
            widget = wibox.widget.textbox,
            markup = "<span color='" .. theme.text .. "'>" .. "2023-12-06 16:33" .. "</span>"
        },
    },
    bg = theme.bg,
    shape_border_width = 2,
    shape_border_color = theme.border,
    widget = wibox.container.background,
    shape = gears.shape.rounded_bar
}

return widget
