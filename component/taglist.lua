local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local theme = require("main.theme")
local taglist_buttons = require("deco.taglist")


local function getTagList(s)
    local widget = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        buttons = taglist_buttons()
    }

    local function update_taglist()
        widget:reset()

        for _, tag in ipairs(awful.screen.focused().tags) do
            local tag_button = wibox.widget {
                {
                    widget = wibox.widget.textbox,
                    text = tag.name,
                    align = "center",
                    valign = "center",
                },
                bg = "#ff0000",
                widget = wibox.container.background
            }

            if tag.selected then
                tag_button.bg = "#00ff00"
            end

            widget:add(tag_button)
        end
    end

    awful.tag.attached_connect_signal(s, "property::selected", update_taglist)
    awful.tag.attached_connect_signal(s, "property::activated", update_taglist)

    update_taglist()

    return widget
end

return getTagList
