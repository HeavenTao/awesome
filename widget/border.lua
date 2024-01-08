local base = require("wibox.widget.base")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("catppuccin.mocha")
local log = require("utils.log")

local border = { mt = {} }

local function new(widgets)
    local border_width = 1.5
    local widget = base.make_widget_declarative(
        {
            {
                {
                    widgets,
                    id = "margin",
                    left = 10,
                    right = 10,
                    widget = wibox.container.margin
                },
                id = "border",
                shape_border_width = border_width,
                shape_border_color = theme.mauve.hex,
                bg = theme.base.hex,
                shape = gears.shape.rounded_bar,
                widget = wibox.container.background,
            },
            layout = wibox.layout.fixed.horizontal
        }
    )

    gears.table.crush(widget, border, true)

    awesome.connect_signal("screen::focus", function(s)
        widget:focus()
    end)

    return widget
end

function border:focus()
    local border = self:get_children_by_id("border")[1]
    if border then
        --border.bg = theme.surface1.hex
    end
end

function border.mt:__call(...)
    return new(...)
end

return setmetatable(border, border.mt)
