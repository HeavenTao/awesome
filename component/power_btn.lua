local wibox = require("wibox")
local theme = require("main.theme")

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

return widget
