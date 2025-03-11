local white = { 1, 1, .8 }
local black = { 0, 0, 0 }

local defaultLineWidth = love.graphics.getLineWidth()
return {
    ---@param x number
    ---@param y number
    ---@param w number
    ---@param h number
    ---@param pos Position
    ---@param color string
    new = function(x, y, w, h, pos, color)
        return {
            w = w,
            h = h,
            pos = pos,
            color = color,
            drawPos = { x = x, y = y }
        }
    end,

    ---@param square Square
    ---@param x number
    ---@param y number
    is_hovered = function(square, x, y)
        return x > square.drawPos.x and
            x < square.drawPos.x + square.w and
            y > square.drawPos.y and
            y < square.drawPos.y + square.h
    end,

    ---@param square Square
    draw = function(square)
        love.graphics.setColor(square.color)
        love.graphics.rectangle("fill", square.drawPos.x, square.drawPos.y, square.w, square.h)
        love.graphics.setColor(black)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", square.drawPos.x, square.drawPos.y, square.w, square.h)
    end,

    ---@param square Square
    draw_selected = function(square)
        love.graphics.setColor(white)
        love.graphics.setLineWidth(4)
        love.graphics.rectangle("line", square.drawPos.x, square.drawPos.y, square.w, square.h)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setLineWidth(defaultLineWidth)
    end
}
