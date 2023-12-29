local awful = require("awful")
local base = require("wibox.widget.base")
local gears = require("gears")
local wibox = require("wibox")
local theme = require("catppuccin.mocha")
local log = require("utils.log")
local common = require("utils.common")

local volume = { mt = {} }

local interval = 2

function volume:up()
    local ring = self:get_children_by_id("ring")[1];
    local value = ring:get_values()[1]
    if value + interval <= 100 then
        ring:set_value(value + interval)
    end
    log.log(ring:get_values()[1])
end

function volume:down()
    local ring = self:get_children_by_id("ring")[1];
    local value = ring:get_values()[1]
    if value - interval >= 0 then
        ring:set_value(value - interval)
    end
    log.log(ring:get_values()[1])
end

function volume:init()
    self._private.is_mute = false

    awful.spawn.easy_async("", function()

    end)
end

function volume:switch_mute()
    self._private.is_mute = not self._private.is_mute

    log.log(tostring(self._private.is_mute))

    local img = self:get_children_by_id("img")[1]

    if self._private.is_mute then
        img.markup = common.build_markup("󰸈", theme.mauve.hex)
    else
        img.markup = common.build_markup("", theme.mauve.hex)
    end
end

local function new(...)
    local widget = base.make_widget_declarative({
        {

            {
                id = "img",
                widget = wibox.widget.textbox,
                markup = common.build_markup("", theme.mauve.hex)
            },
            id = "ring",
            paddings = 0,
            thickness = 2,
            value = 0,
            min_value = 0,
            max_value = 100,
            start_angle = 3 / 2 * math.pi,
            rounded_edge = false,
            colors = {
                theme.mauve.hex
            },
            bg = theme.surface2.hex,
            widget = wibox.container.arcchart
        },
        margins = 3,
        widget = wibox.container.margin,
    })

    gears.table.crush(widget, volume, true)

    widget:buttons(awful.util.table.join(
        awful.button({}, 4, function()
            widget:up()
        end),
        awful.button({}, 5, function()
            widget:down()
        end)
    ))

    local img = widget:get_children_by_id("img")[1]
    img:buttons(awful.util.table.join(
        awful.button({}, 1, function()
            widget:switch_mute()
        end)
    ))

    widget:init()

    return widget
end

function volume.mt:__call(...)
    return new(...)
end

return setmetatable(volume, volume.mt)
