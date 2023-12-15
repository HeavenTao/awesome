local base = require("wibox.widget.base")
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local theme = require("catppuccin.mocha")
local taglist_buttons = require("deco.taglist")
local shape = require("utils.shape")

local taglist = { mt = {} }

function taglist:update_taglist()
    local container = self:get_children_by_id("container")[1]
    container:reset()

    for _, tag in ipairs(awful.screen.focused().tags) do
        local tag_button
        if tag.selected then
            tag_button = wibox.widget {
                fit = function(_, _, width, height)
                    return math.min(width, height), math.min(width, height)
                end,
                draw = function(_, _, cr, width, height)
                    shape.rounded_bar(cr, width, height, 5, theme.mauve.hex)
                end,
                forced_width = 100,
                forced_height = 10
            }
        else
            tag_button = wibox.widget {
                fit = function(_, _, width, height)
                    return math.min(width, height), math.min(width, height)
                end,
                draw = function(_, _, cr, width, height)
                    shape.rounded_bar(cr, width, height, 5, theme.overlay0.hex)
                end,
                forced_width = 25,
                height = 10
            }
        end

        container:add(tag_button)
    end
end

local function new(s)
    local widget = base.make_widget_declarative {
        id = "container",
        spacing = 10,
        layout = wibox.layout.fixed.horizontal,
        buttons = taglist_buttons()
    }

    gears.table.crush(widget, taglist, true)


    awful.tag.attached_connect_signal(s, "property::selected", function()
        widget:update_taglist()
    end)
    awful.tag.attached_connect_signal(s, "property::activated", function()
        widget:update_taglist()
    end)

    widget:update_taglist()

    return widget
end

function taglist.mt:__call(...)
    return new(...)
end

return setmetatable(taglist, taglist.mt)
