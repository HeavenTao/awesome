local _M = {
    build_markup = function(text, color)
        return "<span color='" .. color .. "'>" .. text .. "</span>"
    end
}

return _M
