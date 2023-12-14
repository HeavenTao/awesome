local base = require("wibox.widget.base")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("catppuccin.mocha")
local log = require("utils.log")

local border = { mt = {} }

local function new(widgets)
    local border_width = 1.5
    local rec = base.make_widget_declarative(
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

    gears.table.crush(rec, border, true)
    return rec
end

function border.mt:__call(...)
    return new(...)
end

return setmetatable(border, border.mt)
