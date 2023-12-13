local base = require("wibox.widget.base")
local gears = require("gears")
local theme = require("catppuccin.mocha")

local border = { mt = {} }


function border:fit(context, width, height)
    local w, h = 0, 0
    if self._private.widget then
        w, h = base.fit_widget(self, context, self._private.widget, width - height, height)
        gears.debug.print_warning("w:" .. width .. " h:" .. height)
    end

    if self._private.draw_empty == false and (w == 0 or h == 0) then
        return 0, 0
    end
    return w, h
end

function border:draw(context, cr, width, height)
    local r = height / 2
    cr:arc(r, r, r, 0.5 * math.pi, 1.5 * math.pi)
    cr:arc(width - r, r, r, 1.5 * math.pi, 0.5 * math.pi)
    cr:close_path()
    cr:set_source(theme.Base)
    cr:fill()
end

border.set_widget = base.set_widget_common

function border:get_widget()
    return self._private.widget
end

function border:get_children()
    return { self._private.widget }
end

function border:set_children(children)
    gears.debug.print_warning(gears.debug.dump(self))
    self:set_widget(children[1])
end

local function new(widget)
    local rect = base.make_widget(nil, nil, { enable_properties = true })
    gears.table.crush(rect, border, true)
    if widget then
        rect:set_widget(widget)
    end
    return rect
end

function border.mt:__call(...)
    return new(...)
end

return setmetatable(border, border.mt)
