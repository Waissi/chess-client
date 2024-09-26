return setmetatable(
    {
        new = function(self, x, y, text)
            return setmetatable({
                    x = x,
                    y = y,
                    text = text
                },
                {
                    __index = self
                }
            )
        end,

        ---@param label Label
        draw = function(label)
            love.graphics.setColor(0, 0, 0)
            love.graphics.print(label.text, label.x, label.y)
            love.graphics.setColor(1, 1, 1)
        end
    },
    {
        __index = import "widget"
    }
)
