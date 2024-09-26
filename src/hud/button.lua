return {
    ---@param x number
    ---@param y number
    ---@param w number
    ---@param h number
    ---@param text string
    ---@param callback function
    new = function(x, y, w, h, text, callback)
        return {
            x = x,
            y = y,
            w = w,
            h = h,
            text = text,
            callback = callback,
            state = "idle",
            color = { .75, .7, .6 }
        }
    end,

    ---@param button Button
    ---@param x number
    ---@param y number
    on_mouse_moved = function(button, x, y)
        local hover = x > button.x and
            x < button.x + button.w and
            y > button.y and
            y < button.y + button.h
        button.state = hover and "hover" or "idle"
        return hover
    end,

    ---@param button Button
    on_mouse_pressed = function(button)
        if not (button.state == "hover") then return end
        button.callback()
        return true
    end,

    ---@param button Button
    draw = function(button)
        love.graphics.setColor(button.color)
        love.graphics.rectangle("fill", button.x, button.y, button.w, button.h)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", button.x, button.y, button.w, button.h)
        love.graphics.print(button.text, button.x, button.y)
        love.graphics.setColor(1, 1, 1)
    end
}
