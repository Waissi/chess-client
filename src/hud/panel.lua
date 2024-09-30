local defaultLineWidth = love.graphics.getLineWidth()

return setmetatable(
    {
        ---@param self PanelModule
        ---@param x number
        ---@param y number
        ---@param w number
        ---@param h number
        new = function(self, x, y, w, h)
            return setmetatable(
                {
                    x = x - w / 2,
                    y = y - h / 2,
                    w = w,
                    h = h,
                    color = { .75, .7, .6, .5 }
                },
                { __index = self }
            )
        end,

        ---@param panel Panel
        draw = function(panel)
            love.graphics.setColor(panel.color)
            love.graphics.rectangle("fill", panel.x, panel.y, panel.w, panel.h, 4, 4)
            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.setLineWidth(3)
            love.graphics.rectangle("line", panel.x, panel.y, panel.w, panel.h, 4, 4)
            love.graphics.setColor(1, 1, 1)
            love.graphics.setLineWidth(defaultLineWidth)
        end
    },
    { __index = import "widget" }
)
