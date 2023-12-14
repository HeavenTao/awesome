local gears = require("gears")

local function write_log(message)
    local date = os.date("*t")
    local dateStr = string.format("%d-%02d-%02d %02d:%02d:%02d", date.year, date.month, date.day, date.hour, date.min,
        date.sec)
    local file = io.open(os.getenv("HOME") .. "/.cache/awesome/debug.log", "a")
    if file then
        file:write(dateStr .. " " .. message .. "\n")
        file:close()
    end
end

local _M = {
    log_table = function(table, tag, depth)
        local message = gears.debug.dump_return(table, tag, depth)
        write_log(message)
    end,
    log = function(message)
        write_log(message)
    end
}

return _M
