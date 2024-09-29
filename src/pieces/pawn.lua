---@type Modules
local M = import "modules"
local whiteImg = love.graphics.newImage("assets/w_pawn.png")
local blackImg = love.graphics.newImage("assets/b_pawn.png")

return setmetatable(
    {
        ---@param self PieceModule
        ---@param x number
        ---@param y number
        ---@param color string
        new = function(self, x, y, color)
            return setmetatable({
                    type = "pawn",
                    state = "idle",
                    x = x,
                    y = y,
                    color = color,
                    img = color == "white" and whiteImg or blackImg,
                    hasMoved = false,
                },
                {
                    __index = self
                }
            )
        end,

        ---@param piece Piece
        ---@param square Square
        move = function(piece, square)
            local diff = math.abs(square.gridPos.y - piece.y)
            piece.x, piece.y = square.gridPos.x, square.gridPos.y
            M.players.set_last_piece(piece)
            M.players.set_en_passant(piece.color, diff == 2)
            if piece.hasMoved then return end
            piece.hasMoved = true
        end,

        ---@param piece Piece
        ---@param square Square
        ---@param board Square[][]
        en_passant = function(piece, square, board)
            local lastPiece = M.players.get_last_piece_played()
            local leftSquare = board[piece.y][piece.x - 1]
            local rightSquare = board[piece.y][piece.x + 1]
            local leftPawn = leftSquare and
                leftSquare.piece and
                leftSquare.piece.type == "pawn" and
                leftSquare.piece == lastPiece and
                leftSquare.piece
            local rightPawn = rightSquare and
                rightSquare.piece and
                rightSquare.piece.type == "pawn" and
                rightSquare.piece == lastPiece and
                rightSquare.piece
            if not leftPawn and not rightPawn then return end
            if leftPawn and leftPawn.x == square.gridPos.x and math.abs(square.gridPos.y - leftPawn.y) == 1 then
                return leftPawn
            end
            if rightPawn and rightPawn.x == square.gridPos.x and math.abs(square.gridPos.y - rightPawn.y) == 1 then
                return rightPawn
            end
        end,

        ---@param piece Piece
        ---@param square Square
        can_promote = function(piece, square)
            if not (square.gridPos.y == 1) then return end
            if square.piece and square.piece.type == "king" then return end
            return math.abs(square.gridPos.y - piece.y) == 1
        end

    },
    { __index = M.interface }
)
