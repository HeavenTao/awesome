local awful = require("awful")
local notify = require("naughty")
local beautiful = require("beautiful")
local wibox = require("wibox")

local home = os.getenv("HOME")

awful.screen.connect_for_each_screen(function(s)
	awful.wallpaper({
		screen = s,
		widget = {
			horizontal_fit_policy = "fit",
			vertical_fit_policy = "fit",
			image = home .. "/code/my-awsome/wallpapers/bg.jpg",
			widget = wibox.widget.imagebox,
		},
	})
end)

--local btn = awful.button(nil, awful.button.names.LEFT, function()
--print("hello")
--notify.notification({
--title = "Hello",
--message = "World",
--timeout = 5,
--})
--end, nil)

--root.buttons = btn
