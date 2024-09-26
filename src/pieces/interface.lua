---@type MovementModule
local movement = require "src.movement"
---@type PlayerModule
local players = require "src.players"

return {
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
        local squares = movement.get_possible_squares(piece.type, piece, gameBoard)
        for _, mSquare in ipairs(squares) do
            if mSquare == square then return true end
        end
    end,

    ---@param piece Piece
    ---@param square Square
    move = function(piece, square)
        piece.x, piece.y = square.gridPos.x, square.gridPos.y
        players.set_last_piece(piece)
        if piece.hasMoved then return end
        piece.hasMoved = true
    end
}
