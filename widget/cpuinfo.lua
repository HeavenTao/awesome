local base = require("wibox.widget.base")
local wibox = require("wibox")
local gears = require("gears")
local log = require("utils.log")
local common = require("utils.common")
local theme = require("catppuccin.mocha")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi

local cpuinfo = { mt = {} }

local delay = 1

function cpuinfo:getCpuInfo()
	local lines = io.open("/proc/stat", "r")
	if lines == nil then
		return nil
	end

	local first_line = lines:read("*l")

	local numbers = {}
	for v in string.gmatch(first_line, "%d+") do
		table.insert(numbers, tonumber(v))
	end

	io.close()

	return numbers
end

function cpuinfo:stat(info)
	if info == nil then
		return nil
	end

	local cpu_times = 0
	for i, v in ipairs(info) do
		cpu_times = cpu_times + v
	end

	if self.last_cpu_times ~= 0 and self.last_idle_times ~= 0 then
		local diff_cpu = cpu_times - self.last_cpu_times
		local diff_idle = info[4] - self.last_idle_times

		local rate = (diff_cpu - diff_idle) / diff_cpu * 100
		self:updateText(rate)
	else
		self:updateText(0)
	end

	self.last_cpu_times = cpu_times
	self.last_idle_times = info[4]
end

function cpuinfo:updateText(rate)
	local text = common.build_markup(math.ceil(rate) .. "%", theme.green.hex)
	self.markup = common.build_markup("CPU:", theme.text.hex) .. text
end

function cpuinfo:start()
	gears.timer({
		timeout = delay,
		call_now = true,
		autostart = true,
		callback = function()
			local info = self:getCpuInfo()
			self:stat(info)
		end,
	})
end

local function new(args)
	local widget = base.make_widget_declarative({
		widget = wibox.widget.textbox,
		font = beautiful.font,
		forced_width = dpi(60),
	})

	widget.last_cpu_times = 0
	widget.last_idle_times = 0

	gears.table.crush(widget, cpuinfo, true)

	widget:start()

	return widget
end

function cpuinfo.mt:__call(...)
	return new(...)
end

return setmetatable(cpuinfo, cpuinfo.mt)
