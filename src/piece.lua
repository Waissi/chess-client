return {
    ---@param type string
    ---@param x number
    ---@param y number
    ---@param color string
    new = function(type, x, y, color)
        local path = "assets/" .. color .. "/" .. type .. ".png"
        return {
            type = type,
            state = "idle",
            color = color,
            pos = { x = x, y = y },
            img = love.graphics.newImage(path)
        }
    end,

    ---@param piece Piece
    ---@param hover boolean
    on_hover = function(piece, hover)
        if piece.state == "selected" then return end
        piece.state = hover and "hovered" or "idle"
    end,

    ---@param piece Piece
    on_mouse_pressed = function(piece)
        if not (piece.state == "hovered") then return end
        piece.state = "selected"
        return true
    end,

    ---@param piece Piece?
    unselect = function(piece)
        if not piece then return end
        piece.state = "idle"
    end,

    ---@param piece Piece
    ---@param square Square
    move = function(piece, square)
        piece.pos.x, piece.pos.y = square.pos.x, square.pos.y
    end
}
