local theme = require("catppuccin.mocha")
local beautiful = require("beautiful")
local vars = require("main.user-variables")
local menubar = require("menubar")
local dpi = require("beautiful.xresources").apply_dpi

local _M = {
	init = function(s)
		-- Menubar configuration
		-- Set the terminal for applications that require it
		menubar.utils.terminal = vars.terminal

		menubar.geometry = {
			y = 0,
			height = dpi(25),
		}

		menubar.show_categories = false
		beautiful.menubar_bg_normal = theme.base.hex
		beautiful.menubar_fg_normal = theme.text.hex

		beautiful.menubar_bg_focus = theme.surface2.hex
		beautiful.menubar_fg_focus = theme.text.hex

		beautiful.prompt_bg = theme.base.hex
		beautiful.prompt_fg = theme.text.hex

		beautiful.prompt_bg_cursor = theme.base.hex
		beautiful.prompt_fg_cursor = theme.text.hex
	end,
}

return _M
