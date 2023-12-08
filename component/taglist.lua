local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local theme = require("main.theme")
local taglist_buttons = require("deco.taglist")
local shape = require("utils.shape")


local function getTagList(s)
    local widget = wibox.widget {
        {
            {
                {
                    id = "container",
                    spacing = 10,
                    layout = wibox.layout.fixed.horizontal
                },
                left = 10,
                right = 10,
                widget = wibox.container.margin
            },
            fg = theme.text,
            bg = theme.bg,
            shape_border_width = 2,
            shape_border_color = theme.border,
            shape = gears.shape.rounded_bar,
            widget = wibox.container.background,
        },
        layout = wibox.layout.fixed.horizontal,
        buttons = taglist_buttons()
    }

    local function update_taglist()
        local container = widget:get_children_by_id("container")[1]
        container:reset()

        for _, tag in ipairs(awful.screen.focused().tags) do
            local tag_button
            if tag.selected then
                tag_button = wibox.widget {
                    fit = function(_, _, width, height)
                        return math.min(width, height), math.min(width, height)
                    end,
                    draw = function(_, _, cr, width, height)
                        shape.rounded_bar(cr, 0, height / 2, width, 5, theme.tag_active)
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
                        local y = height / 2
                        shape.circle(cr, 5, y, 5, theme.tag)
                    end
                }
            end

            container:add(tag_button)
        end
    end

    awful.tag.attached_connect_signal(s, "property::selected", update_taglist)
    awful.tag.attached_connect_signal(s, "property::activated", update_taglist)

    update_taglist()

    return widget
end

return getTagList
