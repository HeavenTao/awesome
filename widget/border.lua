local base = require("wibox.widget.base")
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("catppuccin.mocha")
local log = require("utils.log")

local border = { mt = {} }

local borderStyle = {
	active = {
		width = 2,
		color = theme.blue.hex,
	},
	normal = {
		width = 1.5,
		color = theme.mauve.hex,
	},
}

local function updateBorder(widget, isFocus)
	local b = widget:get_children_by_id("border")[1]
	if isFocus then
		b.shape_border_color = borderStyle.active.color
		b.shape_border_width = borderStyle.active.width
	else
		b.shape_border_color = borderStyle.normal.color
		b.shape_border_width = borderStyle.normal.width
	end
end

local function new(widgets, s)
	local widget = base.make_widget_declarative({
		{
			{
				widgets,
				id = "margin",
				left = 10,
				right = 10,
				widget = wibox.container.margin,
			},
			id = "border",
			bg = theme.base.hex,
			shape = gears.shape.rounded_bar,
			widget = wibox.container.background,
		},
		layout = wibox.layout.fixed.horizontal,
	})

	gears.table.crush(widget, border, true)

	s:connect_signal("screen::focused", function()
		updateBorder(widget, true)
	end)

	s:connect_signal("screen::unfocused", function()
		updateBorder(widget, false)
	end)

	local isFocused = true
	if s.index == awful.screen.focused().index then
		isFocused = true
	else
		isFocused = false
	end

	updateBorder(widget, isFocused)

	return widget
end

function border.mt:__call(...)
	return new(...)
end

return setmetatable(border, border.mt)
