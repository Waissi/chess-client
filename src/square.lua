local white = { 1, 1, .8 }
local black = { 0, 0, 0 }

local defaultLineWidth = love.graphics.getLineWidth()
return {
    ---@param x number
    ---@param y number
    ---@param w number
    ---@param h number
    ---@param gridPos Position
    ---@param color string
    new = function(x, y, w, h, gridPos, color)
        return {
            x = x,
            y = y,
            w = w,
            h = h,
            gridPos = gridPos,
            color = color
        }
    end,

    ---@param square Square
    ---@param piece Piece
    occupy = function(square, piece)
        square.piece = piece
    end,

    ---@param square Square
    free = function(square)
        square.piece = nil
    end,

    ---@param square Square
    ---@param x number
    ---@param y number
    is_hovered = function(square, x, y)
        return x > square.x and
            x < square.x + square.w and
            y > square.y and
            y < square.y + square.h
    end,

    ---@param square Square
    draw = function(square)
        love.graphics.setColor(square.color)
        love.graphics.rectangle("fill", square.x, square.y, square.w, square.h)
        love.graphics.setColor(black)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", square.x, square.y, square.w, square.h)
    end,

    ---@param square Square
    draw_selected = function(square)
        love.graphics.setColor(white)
        love.graphics.setLineWidth(4)
        love.graphics.rectangle("line", square.x, square.y, square.w, square.h)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setLineWidth(defaultLineWidth)
    end
}
