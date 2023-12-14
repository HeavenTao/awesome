local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

local function power_btn(parent)
    local color = {
        normal = "#ed8796",
        mouseenter = "#8aadf4",
        restart = "#a6da95"
    }

    local icon = "⏻";

    local widget = wibox.widget {
        widget = wibox.widget.textbox,
        markup = "<span color='" .. color.normal .. "'>" .. "⏻" .. "</span>",
        --font = theme.font .. " 12",
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

    local popup = awful.popup {
        widget       = {
            {
                {
                    id = "shutdown_btn",
                    widget = wibox.widget.textbox,
                    --markup = "<span color='" .. color.normal .. "'>" .. "⏻" .. "</span>" .. "<span color='" .. theme.text .. "'>" .. "  关机" .. "</span>",
                    forced_width = 50,
                    buttons = awful.button({}, 1, function()
                        awful.spawn.with_shell("shutdown 0")
                    end)
                },
                {
                    id = "restart_btn",
                    widget = wibox.widget.textbox,
                    --markup = "<span color='" .. color.restart .. "'>" .. "" .. "</span>" .. "<span color='" .. theme.text .. "'>" .. "  重启" .. "</span>",
                    forced_width = 50,
                    buttons = awful.button({}, 1, function()
                        awful.spawn.with_shell("shutdown -r 0")
                    end)
                },
                layout = wibox.layout.fixed.vertical
            },
            margins = 5,
            widget = wibox.container.margin
        },
        --border_color = theme.border,
        border_width = 2,
        --bg           = theme.bg_normal,
        shape        = gears.shape.rounded_rect,
        visible      = false,
        ontop        = true,
    }

    widget:connect_signal("button::press", function()
        popup.visible = not popup.visible
        if popup.visible then
            popup:move_next_to(parent, "bottom")
        end
    end)

    return widget
end

return power_btn
