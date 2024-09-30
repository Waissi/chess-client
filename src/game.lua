---@type Modules
local M = import "modules"

---@type Piece?
local selectedPiece

---@type string
local playerColor = ""

---@type Player
local currentPlayer

---@type Game?
local game
local is_valid_move = function()
    if not game then return end
    local king = M.players.get_king(playerColor, game.pieces)
    return not M.players.inspect_check(king, game.pieces, game.board)
end

---@param currentPiece Piece
---@param previousPos Position
---@param deadPawn Piece?
---@param promotion string?
local next_turn = function(currentPiece, previousPos, deadPawn, promotion)
    M.piece.unselect(currentPiece)
    selectedPiece = nil
    currentPlayer = M.players.next(currentPlayer)
    M.connection.send_game_data({
        movedPiece = {
            newPos = { x = currentPiece.x, y = currentPiece.y },
            previousPos = { x = previousPos.x, y = previousPos.y }
        },
        deadPawn = deadPawn and { x = deadPawn.x, y = deadPawn.y },
        promotion = promotion
    })
end

local is_checkmate = function()
    if not game then return end
    local king = M.players.get_king(playerColor, game.pieces)
    for _, piece in ipairs(game.pieces[playerColor]) do
        local currentSquare = game.board[piece.y][piece.x]
        local squares = M.movement.get_possible_squares(piece.type, piece, game.board)
        for _, square in ipairs(squares) do
            local deadPiece
            if square.piece and not (square.piece.type == "king") then
                deadPiece = square.piece
                table.delete(game.pieces[square.piece.color], square.piece)
                M.square.free(square)
            end
            M.square.free(currentSquare)
            M.square.occupy(square, piece)
            local hasMoved = piece.hasMoved
            M.piece.move(piece, square)
            local check = M.players.inspect_check(king, game.pieces, game.board)
            M.square.free(square)
            M.square.occupy(currentSquare, piece)
            M.piece.move(piece, currentSquare)
            piece.hasMoved = hasMoved
            if deadPiece then
                table.insert(game.pieces[deadPiece.color], deadPiece)
                M.square.occupy(square, deadPiece)
            end
            if not check then return end
        end
    end
    return true
end

return {
    ---@param color string
    init = function(color)
        playerColor = color
        M.players.init()
        M.movement.init(playerColor)
        M.coordinates.init(playerColor)
        currentPlayer = M.players.get_player("white")
        game = {
            board = M.board.new(),
            pieces = {
                white = {},
                black = {}
            }
        }
        local startPos = M.position.init_start_positions(playerColor)
        for number, list in pairs(startPos) do
            for letter, piece in pairs(list) do
                local x = M.coordinates.get_index(letter)
                local y = number
                table.insert(game.pieces[piece.color], M.piece.new(piece.type, x, y, piece.color))
            end
        end

        for _, colorPieces in pairs(game.pieces) do
            for _, piece in ipairs(colorPieces) do
                local square = game.board[piece.y][piece.x]
                M.square.occupy(square, piece)
            end
        end
        M.position.get_repetition(game.pieces)
        M.hud.push_menu("game")
        M.connection.start_game(color == "white" and "black" or "white")
        return game
    end,

    release = function()
        game = nil
        playerColor = ""
        M.hud.push_menu("connection")
    end,

    ---@param x number
    ---@param y number
    on_mouse_moved = function(x, y)
        if not game then return end
        if not (currentPlayer.color == playerColor) then return end
        local hover = false
        for _, piece in ipairs(game.pieces[playerColor]) do
            local square = game.board[piece.y][piece.x]
            local isHovered = M.square.is_hovered(square, x, y)
            hover = isHovered and true or hover
            M.piece.on_hover(piece, isHovered)
        end
        return hover
    end,

    ---@param x number
    ---@param y number
    ---@param button number
    on_mouse_pressed = function(x, y, button)
        if not game then return end
        if not (currentPlayer.color == playerColor) then return end
        if button == 2 then
            if not selectedPiece then return end
            M.piece.unselect(selectedPiece)
            selectedPiece = nil
            return
        end
        if selectedPiece then
            local currentSquare = game.board[selectedPiece.y][selectedPiece.x]
            local square = M.board.get_hovered_square(game.board, x, y)
            local opponentKing = M.players.get_opponent_king(playerColor, game.pieces)
            local kingSquare = game.board[opponentKing.y][opponentKing.x]
            if square and not (square == kingSquare) then
                if selectedPiece.type == "pawn" then
                    if M.players.can_promote(selectedPiece, square) then
                        local newQueen = M.piece.new("queen", square.gridPos.x, square.gridPos.y, selectedPiece.color)
                        table.delete(game.pieces[selectedPiece.color], selectedPiece)
                        table.insert(game.pieces[selectedPiece.color], newQueen)
                        local deadPiece = square.piece
                        if deadPiece then
                            M.square.free(square)
                            table.delete(game.pieces[deadPiece.color], deadPiece)
                        end
                        M.square.free(currentSquare)
                        M.square.occupy(square, newQueen)
                        if is_valid_move(game) then
                            next_turn(newQueen, currentSquare.gridPos, nil, "queen")
                            return
                        end
                        M.square.occupy(currentSquare, selectedPiece)
                        M.square.free(square, newQueen)
                        table.insert(game.pieces[selectedPiece.color], selectedPiece)
                        table.delete(game.pieces[selectedPiece.color], newQueen)
                        if deadPiece then
                            M.square.occupy(square, deadPiece)
                            table.insert(game.pieces[deadPiece.color], deadPiece)
                        end
                        return
                    end
                    if M.players.can_perform_en_passant(currentPlayer) then
                        local deadPawn = M.players.get_dead_pawn_en_passant(selectedPiece, square, game.board)
                        if deadPawn then
                            local deadPawnSquare = game.board[deadPawn.y][deadPawn.x]
                            table.delete(game.pieces[deadPawn.color], deadPawn)
                            M.square.free(currentSquare)
                            M.square.free(deadPawnSquare)
                            M.square.occupy(square, selectedPiece)
                            M.piece.move(selectedPiece, square)
                            if is_valid_move(game) then
                                next_turn(selectedPiece, currentSquare.gridPos, deadPawn)
                                return
                            end
                            M.piece.move(selectedPiece, currentSquare)
                            M.square.free(square)
                            M.square.occupy(currentSquare, selectedPiece)
                            if deadPawn then
                                M.square.occupy(deadPawnSquare, deadPawn)
                                table.insert(game.pieces[deadPawn.color], deadPawn)
                            end
                            return
                        end
                    end
                end
                local castling, castlingMovement = M.players.can_perform_castling(selectedPiece, square, game.board)
                if castling then
                    M.square.occupy(castlingMovement.intermediate, selectedPiece)
                    M.square.free(currentSquare)
                    M.piece.move(selectedPiece, castlingMovement.intermediate)
                    local check = M.players.inspect_check(selectedPiece, game.pieces, game.board)
                    M.square.free(castlingMovement.intermediate)
                    M.square.occupy(currentSquare, selectedPiece)
                    if check then
                        M.piece.move(selectedPiece, currentSquare)
                        selectedPiece.hasMoved = false
                        return
                    end
                    M.square.occupy(square, selectedPiece)
                    M.square.occupy(castlingMovement.newPos, castlingMovement.tower)
                    M.square.free(currentSquare)
                    M.square.free(castlingMovement.lastPos)
                    M.piece.move(selectedPiece, square)
                    M.piece.move(castlingMovement.tower, castlingMovement.newPos)
                    if is_valid_move(game) then
                        next_turn(selectedPiece, currentSquare.gridPos)
                        return
                    end
                    selectedPiece.hasMoved = false
                    M.piece.move(selectedPiece, currentSquare)
                    castlingMovement.tower.hasMoved = false
                    M.piece.move(castlingMovement.tower, castlingMovement.lastPos)
                    M.square.free(square)
                    M.square.occupy(currentSquare, selectedPiece)
                    M.square.free(castlingMovement.newPos)
                    M.square.occupy(castlingMovement.lastPos, castlingMovement.tower)
                    return
                end
                if M.piece.can_move(selectedPiece, square, game.board) then
                    local deadPiece = square.piece
                    if deadPiece then
                        table.delete(game.pieces[square.piece.color], deadPiece)
                    end
                    M.square.free(currentSquare)
                    M.square.occupy(square, selectedPiece)
                    M.piece.move(selectedPiece, square)
                    if is_valid_move(game) then
                        next_turn(selectedPiece, currentSquare.gridPos)
                        return
                    end
                    M.piece.move(selectedPiece, currentSquare)
                    M.square.free(square)
                    M.square.occupy(currentSquare, selectedPiece)
                    if deadPiece then
                        M.square.occupy(square, deadPiece)
                        table.insert(game.pieces[deadPiece.color], deadPiece)
                    end
                    return
                end
            end
        end
        for _, piece in ipairs(game.pieces[playerColor]) do
            if M.piece.on_mouse_pressed(piece) then
                if selectedPiece then
                    M.piece.unselect(selectedPiece)
                end
                selectedPiece = piece
                return
            end
        end
    end,

    ---@param gameData table
    receive_game_data = function(gameData)
        if not game then return end
        local newX, newY = M.coordinates.translate(gameData.movedPiece.newPos)
        local newSquare = game.board[newY][newX]
        if newSquare.piece then
            table.delete(game.pieces[playerColor], newSquare.piece)
            M.square.free(newSquare)
        end
        local pieceX, pieceY = M.coordinates.translate(gameData.movedPiece.previousPos)
        local pieceSquare = game.board[pieceY][pieceX]
        local piece = pieceSquare.piece
        if not piece then
            error("something went wrong")
        end
        if piece.type == "king" then
            --check if we are performing castling
            local diff = newSquare.gridPos.x - pieceSquare.gridPos.x
            if math.abs(diff) == 2 then
                local dir = diff > 0 and "right" or "left"
                local towerX = dir == "right" and 8 or 1
                local towerSquare = game.board[1][towerX]
                local mvt
                if piece.color == "white" then
                    mvt = dir == "right" and -3 or 2
                else
                    mvt = dir == "left" and 3 or -2
                end
                local newTowerSqaure = game.board[1][towerX + mvt]
                local tower = towerSquare.piece
                if not tower then
                    error("something went wrong")
                end
                M.square.free(towerSquare)
                M.square.occupy(newTowerSqaure, tower)
                M.piece.move(tower, newTowerSqaure)
            end
        end
        M.piece.move(piece, newSquare)
        M.square.free(pieceSquare)
        M.square.occupy(newSquare, piece)
        if gameData.promotion then
            local newPiece = M.piece.new(gameData.promotion, 0, 0, piece.color)
            table.insert(game.pieces[piece.color], newPiece)
            table.delete(game.pieces[piece.color], piece)
            M.square.free(newSquare)
            M.piece.move(newPiece, newSquare)
            M.square.occupy(newSquare, newPiece)
        end
        if gameData.deadPawn then
            local pawnX, pawnY = M.coordinates.translate(gameData.deadPawn)
            local pawnSquare = game.board[pawnY][pawnX]
            local pawn = pawnSquare.piece
            if not pawn then
                error("something went wrong")
            end
            table.delete(game.pieces[pawn.color], pawn)
            M.square.free(pawnSquare)
        end
        local repetition = M.position.get_repetition(game.pieces)
        if repetition == 3 then
            M.hud.push_menu("threefold")
            return
        elseif repetition == 5 then
            M.hud.push_menu("fivefold")
            return
        end
        local king = M.players.get_king(playerColor, game.pieces)
        if M.players.inspect_check(king, game.pieces, game.board) then
            if is_checkmate() then
                M.hud.push_menu("checkmate")
                return
            end
        end
        currentPlayer = M.players.get_player(playerColor)
    end,

    continue_playing = function()
        currentPlayer = M.players.get_player(playerColor)
    end,

    draw = function()
        if not game then return end
        M.board.draw(game.board)
        love.graphics.setColor(1, 1, 1, 1)
        for _, colorPieces in pairs(game.pieces) do
            for _, piece in ipairs(colorPieces) do
                local square = game.board[piece.y][piece.x]
                love.graphics.draw(piece.img, square.x, square.y)
            end
        end
        if selectedPiece then
            local square = game.board[selectedPiece.y][selectedPiece.x]
            M.square.draw_selected(square)
        end
    end
}
