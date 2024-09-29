---@type Piece
local lastPiece

local players = {
    white = {
        color = "white",
        check = false,
        enPassantVulnerable = false
    },
    black = {
        color = "black",
        check = false,
        enPassantVulnerable = false
    }
}

return {
    ---@param color string
    get_player = function(color)
        return players[color]
    end,

    next = function(currentPlayer)
        local color = currentPlayer.color == "white" and "black" or "white"
        return players[color]
    end,

    ---@param piece Piece
    set_last_piece = function(piece)
        lastPiece = piece
    end,

    get_last_piece_played = function()
        return lastPiece
    end,

    ---@param color string
    ---@param bool boolean
    set_en_passant = function(color, bool)
        players[color].enPassantVulnerable = bool
    end,

    ---@param currentPlayer Player
    can_perform_en_passant = function(currentPlayer)
        local color = currentPlayer.color == "white" and "black" or "white"
        return players[color].enPassantVulnerable
    end,

    ---@param king Piece
    ---@param square Square
    ---@param board Square[][]
    can_perform_castling = function(king, square, board)
        if not (king.type == "king") or king.hasMoved or players[king.color].check or square.piece then return end
        local distance = square.gridPos.x - king.x
        if not (math.abs(distance) == 2) then return end
        local dir = distance > 0 and "right" or "left"
        local movement = dir == "right" and 1 or -1
        local nextSquare = board[king.y][king.x + movement]
        if nextSquare.piece then return end
        local x = dir == "left" and 1 or 8
        local y = king.color == "black" and 1 or 8
        if not (square.gridPos.y == y) then return end
        local tower = board[y][x].piece
        if not tower or tower.hasMoved then return end
        if dir == "left" and board[y][tower.x + 1].piece then return end
        local towerMovement = dir == "left" and 3 or -2
        return true,
            {
                tower = tower,
                lastPos = board[y][tower.x],
                newPos = board[y][tower.x + towerMovement],
                intermediate = nextSquare
            }
    end,

    ---@param king Piece
    ---@param pieces Piece[]
    ---@param board Square[][]
    inspect_check = function(king, pieces, board)
        local color = king.color == "white" and "black" or "white"
        local kingSquare = board[king.y][king.x]
        local check = false
        for _, piece in ipairs(pieces[color]) do
            if piece:can_move(kingSquare, board) then
                check = true
                break
            end
        end
        players[king.color].check = check
    end,

    ---@param currentPlayer Player
    ---@param pieces Piece[]
    get_current_player_king = function(currentPlayer, pieces)
        for _, piece in ipairs(pieces[currentPlayer.color]) do
            if piece.type == "king" then
                return piece
            end
        end
        error("A king should always be there")
    end,

    ---@param currentPlayer Player
    ---@param pieces Piece[]
    get_opponent_king = function(currentPlayer, pieces)
        local color = currentPlayer.color == "white" and "black" or "white"
        for _, piece in ipairs(pieces[color]) do
            if piece.type == "king" then
                return piece
            end
        end
        error("A king should always be there")
    end
}
