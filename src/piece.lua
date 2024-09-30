---@type Modules
local M = import "modules"

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
            x = x,
            y = y,
            color = color,
            img = love.graphics.newImage(path),
            hasMoved = false,
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

    ---@param piece Piece
    unselect = function(piece)
        piece.state = "idle"
    end,

    ---@param piece Piece
    ---@param square Square
    ---@param gameBoard Square[]
    can_move = function(piece, square, gameBoard)
        if square.piece and (square.piece.color == piece.color) then return end
        local squares = M.movement.get_possible_squares(piece.type, piece, gameBoard)
        for _, mSquare in ipairs(squares) do
            if mSquare == square then return true end
        end
    end,

    ---@param piece Piece
    ---@param square Square
    move = function(piece, square)
        if piece.type == "pawn" then
            local diff = math.abs(square.gridPos.y - piece.y)
            M.players.set_en_passant(piece.color, diff == 2)
        end
        piece.x, piece.y = square.gridPos.x, square.gridPos.y
        M.players.set_last_piece(piece)
        if piece.hasMoved then return end
        piece.hasMoved = true
    end
}
