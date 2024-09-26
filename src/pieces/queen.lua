---@type Modules
local M = import "modules"
local whiteImg = love.graphics.newImage("assets/w_queen.png")
local blackImg = love.graphics.newImage("assets/b_queen.png")

return setmetatable(
    {
        ---@param self PieceModule
        ---@param x number
        ---@param y number
        ---@param color string
        new = function(self, x, y, color)
            return setmetatable({
                    type = "queen",
                    state = "idle",
                    x = x,
                    y = y,
                    color = color,
                    hasMoved = false,
                    img = color == "white" and whiteImg or blackImg,
                },
                {
                    __index = self
                }
            )
        end,

        ---@param piece Piece
        ---@param square Square
        ---@param board Square[][]
        can_move = function(piece, square, board)
            if square.piece and (square.piece.color == piece.color) then return end
            local squares1 = M.movement.get_possible_squares("bishop", piece, board)
            local squares2 = M.movement.get_possible_squares("rook", piece, board)
            local squares = table.combine(squares1, squares2)
            for _, mSquare in ipairs(squares) do
                if mSquare == square then return true end
            end
        end,

    },
    { __index = M.interface }
)
