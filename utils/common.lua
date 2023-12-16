local _M = {
    build_markup = function(text, color, is_b)
        if is_b then
            return "<span color='" .. color .. "'>" .. "<b>" .. text .. "</b>" .. "</span>"
        else
            return "<span color='" .. color .. "'>" .. text .. "</span>"
        end
    end,
}

return _M
