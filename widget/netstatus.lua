local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local theme = require("catppuccin.mocha")
local common = require("utils.common")
local json = require("lunajson")
local log = require("utils.log")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi

local netstatus = { mt = {} }

local icon = {
	upload = {
		icon = " ",
		icon_color = theme.red.hex,
	},
	download = {
		icon = " ",
		icon_color = theme.green.hex,
	},
	open = {
		icon = " ",
		icon_color = theme.green.hex,
	},
	close = {
		icon = "󰖪 ",
		icon_color = theme.red.hex,
	},
}

local delay = 5

function netstatus:update_text(rx_speed, tx_speed, net_status)
	local net_status_text = ""
	if net_status == "UP" then
		net_status_text = common.build_markup(icon.open.icon, icon.open.icon_color)
	else
		net_status_text = common.build_markup(icon.close.icon, icon.close.icon_color)
	end

	local rx_abbr = "kb/s"
	local tx_abbr = "kb/s"

	if rx_speed > 1024 then
		rx_speed = rx_speed / 1024
		rx_abbr = "Mb/s"
	end

	if tx_speed > 1024 then
		tx_speed = tx_speed / 1024
		tx_abbr = "Mb/s"
	end

	local rx_text = common.build_markup(string.format("%.0f", rx_speed) .. rx_abbr, icon.download.icon_color)

	local tx_text = common.build_markup(string.format("%.0f", tx_speed) .. tx_abbr, icon.upload.icon_color)

	self.markup = net_status_text .. rx_text .. " " .. tx_text
end

function netstatus:start()
	gears.timer({
		timeout = delay,
		call_now = true,
		autostart = true,
		callback = function()
			self:getSpeed()
		end,
	})
end

function netstatus:getSpeed()
	awful.spawn.easy_async("ip -s -h -j link", function(stdout)
		local status_data = json.decode(stdout)
		local interface = 2

		local rx_bytes = status_data[interface].stats64.rx.bytes
		local tx_bytes = status_data[interface].stats64.tx.bytes

		local net_status = status_data[interface].operstate

		if self._private.last_tx_bytes ~= 0 and self._private.last_rx_bytes ~= 0 then
			local rx_speed = (rx_bytes - self._private.last_rx_bytes) / 1024 / delay
			local tx_speed = (tx_bytes - self._private.last_tx_bytes) / 1024 / delay

			self:update_text(rx_speed, tx_speed, net_status)
		else
			self:update_text(0, 0, "UP")
		end

		self._private.last_rx_bytes = rx_bytes
		self._private.last_tx_bytes = tx_bytes
	end)
end

local function new(args)
	local widget = wibox.widget({
		widget = wibox.widget.textbox,
		markup = "",
		font = beautiful.font,
		forced_width = dpi(150),
	})

	gears.table.crush(widget, netstatus, true)

	widget._private.last_rx_bytes = 0
	widget._private.last_tx_bytes = 0

	widget:start()

	return widget
end

function netstatus.mt:__call(...)
	return new(...)
end

return setmetatable(netstatus, netstatus.mt)
