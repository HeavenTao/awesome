local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local json = require("lunajson")
local theme = require("main.theme")

local function net_status()
    local widget = wibox.widget {
        widget = wibox.widget.textbox,
        markup = ""
    }

    local last_rx_bytes = 0
    local last_tx_bytes = 0
    local delay = 5
    local upload = {
        icon = "",
        icon_color = theme.text,
        color = theme.text
    }
    local download = {
        icon = "",
        icon_color = theme.text,
        color = theme.text
    }
    local status = {
        open_icon = "",
        close_icon = "󰖪"
    }

    local function update_text(rx_speed, tx_speed, net_status)
        local net_icon = status.close_icon
        if net_status == "UP" then
            net_icon = status.open_icon
        end

        local rx_icon = "<span color='" .. download.icon_color .. "'>" .. download.icon .. "</span>"
        local rx_text = "<span color='" ..
            download.color .. "'>" .. string.format("%.2f", rx_speed) .. "kb/s" .. "</span>"

        local tx_icon = "<span color='" .. upload.icon_color .. "'>" .. upload.icon .. "</span>"
        local tx_text = "<span color='" .. upload.color .. "'>" .. string.format("%.2f", tx_speed) .. "kb/s" .. "</span>"

        local net_text = "<span color='" .. theme.text .. "'>" .. net_icon .. "</span>"
        widget.markup = net_text .. " " .. rx_icon .. "  " .. rx_text .. "  " .. tx_icon .. "  " .. tx_text
    end

    gears.timer {
        timeout = delay,
        call_now = true,
        autostart = true,
        callback = function()
            awful.spawn.easy_async("ip -s -h -j link", function(stdout)
                local status_data = json.decode(stdout)
                local interface = 2


                local rx_bytes = status_data[interface].stats64.rx.bytes
                local tx_bytes = status_data[interface].stats64.tx.bytes

                local status = status_data[interface].operstate;

                if last_tx_bytes ~= 0 and last_rx_bytes ~= 0 then
                    local rx_speed = (rx_bytes - last_rx_bytes) / 1024 / delay
                    local tx_speed = (tx_bytes - last_tx_bytes) / 1024 / delay

                    gears.debug.print_warning("RX:" .. string.format("%.2f", rx_speed) .. 'kb/s')
                    gears.debug.print_warning("TX:" .. string.format("%.2f", tx_speed) .. 'kb/s')

                    update_text(rx_speed, tx_speed, status)
                end

                last_rx_bytes = rx_bytes
                last_tx_bytes = tx_bytes
            end)
        end
    }

    return widget
end

return net_status
