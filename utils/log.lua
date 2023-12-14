local gears = require("gears")

local _M = {
    logtable = function(table, tag, dept)
        gears.debug.print_warning("****************************************")
        gears.debug.print_warning(gears.debug.dump_return(table, tag, dept))
        gears.debug.print_warning("****************************************")
    end,
    log = function(msg)
        gears.debug.print_warning("****************************************")
        gears.debug.print_warning(msg)
        gears.debug.print_warning("****************************************")
    end
}

return _M
