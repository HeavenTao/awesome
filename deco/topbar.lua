-- Standard awesome library
local awful = require("awful")
local log = require("utils.log")
local wibox = require("wibox")
local vars = require("main.user-variables")
local wallpaper = require("deco.wallpaper")
local dpi = require("beautiful.xresources").apply_dpi

--components
local timer = require("widget.timer")
local taglist = require("widget.taglist")
local powerbtn = require("widget.powerbtn")
local netstatus = require("widget.netstatus")
local border = require("widget.border")
local cpuinfo = require("widget.cpuinfo")
local meminfo = require("widget.meminfo")
local volumn = require("widget.volume")
local menubar = require("widget.menubar")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- {{{ Wibar
-- Create a textclock widget

awful.screen.connect_for_each_screen(function(s)
	menubar.init(s)
	-- Wallpaper
	set_wallpaper(s)

	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()

	-- Create the wibox
	s.mywibox = awful.wibar({ position = "top", screen = s, bg = "#00000000", height = dpi(25) })
	if s.index == vars.primaryscreen then
		-- Add widgets to the wibox
		s.mywibox:setup({
			layout = wibox.layout.align.horizontal,
			expand = "outside",
			{
				border({
					taglist(s),
					s.mypromptbox,
					spacing = dpi(8),
					layout = wibox.layout.fixed.horizontal,
				}, s),
				halign = "left",
				widget = wibox.container.place,
			},
			border(timer(), s),
			{
				border({
					volumn(),
					meminfo(),
					cpuinfo(),
					netstatus(),
					powerbtn(s),
					spacing = dpi(8),
					layout = wibox.layout.fixed.horizontal,
				}, s),
				halign = "right",
				widget = wibox.container.place,
			},
		})
	else
		-- Add widgets to the wibox
		s.mywibox:setup({
			layout = wibox.layout.align.horizontal,
			expand = "outside",
			{
				border({
					taglist(s),
					s.mypromptbox,
					spacing = dpi(8),
					layout = wibox.layout.fixed.horizontal,
				}, s),
				halign = "left",
				widget = wibox.container.place,
			},
		})
	end
end)
-- }}}
