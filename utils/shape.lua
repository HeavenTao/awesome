local gears = require("gears")

local _M = {
    circle = function(cr, cx, cy, r, color)
        cr:arc(cx, cy, r, 0, 2 * math.pi)
        cr:close_path()
        cr:set_source(gears.color(color))
        cr:fill()
    end,
    rounded_bar = function(cr, x, cy, width, r, color)
        cr:arc(x + r, cy, r, 0.5 * math.pi, 1.5 * math.pi)
        cr:arc(x + width - r, cy, r, 1.5 * math.pi, 0.5 * math.pi)
        cr:close_path()
        cr:set_source(gears.color(color))
        cr:fill()
    end
}

return _M
