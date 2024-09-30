---@type Modules
local M = import "modules"

return setmetatable({
        ---@param self ButtonModule
        ---@param x number
        ---@param y number
        ---@param w number
        ---@param h number
        ---@param text string
        ---@param fontSize number
        ---@param callback function
        new = function(self, x, y, w, h, text, fontSize, callback)
            return setmetatable({
                    x = x,
                    y = y,
                    w = w,
                    h = h,
                    label = M.label:new(x + w / 2, y + h / 2, text, fontSize),
                    callback = callback,
                    state = "idle",
                    color = { .25, .2, .2 },
                    labelColor = { 1, 1, 1 }
                },
                { __index = self })
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
            love.graphics.rectangle("fill", button.x, button.y, button.w, button.h, 4, 4)
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle("line", button.x, button.y, button.w, button.h, 4, 4)
            button.label:draw(button.labelColor)
        end
    },
    {
        __index = import "widget"
    }
)
