local wibox = require("wibox")
local theme = require("main.theme")
local gears = require("gears")
local awful = require("awful")

local color = {
    normal = "#ed8796",
    mouseenter = "#8aadf4"
}

local icon = "⏻";

local widget = wibox.widget {
    widget = wibox.widget.textbox,
    markup = "<span color='" .. color.normal .. "'>" .. "⏻" .. "</span>",
    font = theme.font .. " 12",
    forced_width = 16,
}

local function update_status(color)
    widget.markup = "<span color='" .. color .. "'>" .. icon .. "</span>"
end

update_status(color.normal)

widget:connect_signal("mouse::enter", function()
    update_status(color.mouseenter)
end)

widget:connect_signal("mouse::leave", function()
    update_status(color.normal)
end)

widget:connect_signal("button::press", function()
    awful.popup {
        widget       = {
            {
                {
                    value = 0.5,
                    forced_width = 100,
                    forced_height = 30,
                    widget = wibox.widget.progressbar
                },
                layout = wibox.layout.fixed.vertical
            },
            margins = 10,
            widget = wibox.container.margin
        },
        border_color = "#11ff00",
        border_width = 5,
        placement    = awful.placement.top_left,
        shape        = gears.shape.rounded_rect,
        visible      = true,
        ontop        = true,
    }
end)

return widget
