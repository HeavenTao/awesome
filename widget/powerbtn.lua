local base = require("wibox.widget.base")
local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local theme = require("catppuccin.mocha")
local beautiful = require("beautiful")
local common = require("utils.common")
local log = require("utils.log")


local powerbtn = { mt = {} }

local icon = {
    normal = {
        icon = " ",
        color = theme.red.hex,
    },
    mouseover = {
        icon = " ",
        color = theme.overlay0.hex,
    }
}

local menus = {
    {
        text = "关机",
        icon = " ",
        icon_color = theme.red.hex,
        action = function()
            awful.spawn.with_shell("shutdown 0")
        end
    },
    {
        text = "重启",
        icon = " ",
        icon_color = theme.green.hex,
        action = function()
            awful.spawn.with_shell("shutdown -r 0")
        end
    }
}

function powerbtn:set_normal()
    self.markup = common.build_markup(icon.normal.icon, icon.normal.color)
end

function powerbtn:set_mouseover()
    self.markup = common.build_markup(icon.mouseover.icon, icon.mouseover.color)
end

function powerbtn:set_popup(s)
    local popup = awful.popup {
        widget        = {},
        border_color  = theme.mauve.hex,
        border_width  = 1.5,
        bg            = theme.crust.hex,
        shape         = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 6)
        end,
        maximum_width = 400,
        visible       = false,
        ontop         = true,
        offset        = { y = 5 }
    }

    self:buttons(
        awful.util.table.join(
            awful.button({}, 1, function()
                if popup.visible then
                    popup.visible = not popup.visible
                else
                    popup:move_next_to(mouse.current_widget_geometry)
                end
            end)
        )
    )

    local rows = { layout = wibox.layout.fixed.vertical }

    for _, item in ipairs(menus) do
        local row = wibox.widget {
            {
                {
                    {
                        markup = common.build_markup(item.icon, item.icon_color),
                        widget = wibox.widget.textbox,
                    },
                    {
                        text = item.text,
                        widget = wibox.widget.textbox,
                    },
                    spacing = 5,
                    layout = wibox.layout.fixed.horizontal
                },
                left = 8,
                right = 8,
                top = 3,
                bottom = 3,
                widget = wibox.container.margin
            },
            bg = theme.crust.hex,
            widget = wibox.container.background
        }
        row:connect_signal("mouse::enter", function(c)
            c:set_bg(theme.overlay0.hex)
        end)

        row:connect_signal("mouse::leave", function(c)
            c:set_bg(theme.crust.hex)
        end)
        row:buttons(
            awful.util.table.join(
                awful.button({}, 1, function()
                    popup.visible = not popup.visible
                    item.action()
                end)
            )
        )

        table.insert(rows, row)
    end

    popup:setup(rows)
end

local function new(parent)
    local widget = base.make_widget_declarative({
        font = beautiful.font,
        widget = wibox.widget.textbox,
        forced_height = 25
    })

    gears.table.crush(widget, powerbtn, true)

    widget:set_normal()

    widget:connect_signal("mouse::enter", function()
        widget:set_mouseover()
    end)

    widget:connect_signal("mouse::leave", function()
        widget:set_normal()
    end)

    widget:set_popup()

    return widget
end

function powerbtn.mt:__call(...)
    return new(...)
end

return setmetatable(powerbtn, powerbtn.mt)
