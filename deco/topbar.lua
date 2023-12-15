-- Standard awesome library
local gears            = require("gears")
local awful            = require("awful")
local theme            = require("catppuccin.mocha")
-- Wibox handling library
local wibox            = require("wibox")

-- Custom Local Library: Common Functional Decoration
local deco             = {
    wallpaper = require("deco.wallpaper"),
    taglist   = require("deco.taglist"),
    tasklist  = require("deco.tasklist")
}

local taglist_buttons  = deco.taglist()
local tasklist_buttons = deco.tasklist()

--components
local timer            = require("widget.timer")
local taglist          = require("widget.taglist")
local powerbtn         = require("widget.powerbtn")
local netstatus        = require("widget.netstatus")
local border           = require("widget.border")

local _M               = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- {{{ Wibar
-- Create a textclock widget

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)
    ))

    -- Create a tasklist widget
    --s.mytasklist = awful.widget.tasklist {
    --screen  = s,
    --filter  = awful.widget.tasklist.filter.currenttags,
    --buttons = tasklist_buttons
    --}

    -- Create the wibox
    local border_width = 1.5
    s.mywibox = awful.wibar({ position = "top", screen = s, bg = "#00000000", height = 25 })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        expand = "outside",
        border(taglist(s)),
        border(timer()),
        {
            border({
                netstatus(),
                powerbtn(s),
                spacing = 8,
                layout = wibox.layout.fixed.horizontal
            }),
            halign = "right",
            widget = wibox.container.place
        },
        --{
        --{
        --{
        --{
        --net_status(),
        --left = 10,
        --right = 5,
        --widget = wibox.container.margin
        --},
        --{
        --power_btn(s.mywibox),
        --left = 10,
        --right = 5,
        --widget = wibox.container.margin
        --},
        --layout = wibox.layout.fixed.horizontal
        --},
        --bg = theme.bg,
        --shape_border_width = 2,
        --shape_border_color = theme.border,
        --widget = wibox.container.background,
        --shape = gears.shape.rounded_bar,
        --},
        --halign = "right",
        --widget = wibox.container.place
        --}
    }
end)
-- }}}
