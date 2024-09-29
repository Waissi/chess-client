---@type Modules
local M = import "modules"
local black = { 0, 0, 0 }
return setmetatable(
    {
        ---@param self LabelModule
        ---@param x number
        ---@param y number
        ---@param text string
        ---@param size number
        new = function(self, x, y, text, size)
            local font = M.font.get_font(size)
            local textW, textH = M.font.get_text_dimensions(font, text)
            return setmetatable({
                    x = x - textW / 2,
                    y = y - textH / 2,
                    text = text,
                    font = font
                },
                {
                    __index = self
                }
            )
        end,

        ---@param label Label
        ---@param color table?
        draw = function(label, color)
            love.graphics.setColor(color or black)
            love.graphics.setFont(label.font)
            love.graphics.print(label.text, label.x, label.y)
        end
    },
    {
        __index = import "widget"
    }
)
