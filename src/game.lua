---@type Modules
local M = import "modules"

---@type PieceModule[]
local pieces = {
    pawn = import "pawn",
    rook = import "rook",
    knight = import "knight",
    bishop = import "bishop",
    queen = import "queen",
    king = import "king",
}

---@type Piece?
local selectedPiece

---@type Player
local currentPlayer

local startPos = import "positions"

---@type Game
local game
local validate_turn = function()
    local king = M.players.get_current_player_king(currentPlayer, game.pieces)
    M.players.inspect_check(king, game.pieces, game.board)
    return not currentPlayer.check
end

return {
    init = function(color)
        currentPlayer = M.players.init(color)
        M.movement.init(currentPlayer.color)
        M.coordinates.init(currentPlayer.color)
        game = {
            board = M.board.new(),
            pieces = {
                white = {},
                black = {}
            }
        }
        for number, list in pairs(startPos[currentPlayer.color]) do
            for letter, piece in pairs(list) do
                local x = M.coordinates.get_index(letter)
                local y = number
                table.insert(game.pieces[piece.color], pieces[piece.type]:new(x, y, piece.color))
            end
        end

        for _, colorPieces in pairs(game.pieces) do
            for _, piece in ipairs(colorPieces) do
                local square = game.board[piece.y][piece.x]
                M.square.occupy(square, piece)
            end
        end
        M.hud.push_menu("game")
        return game
    end,

    ---@param x number
    ---@param y number
    on_mouse_moved = function(x, y)
        if not currentPlayer then return end
        local hover = false
        for _, piece in ipairs(game.pieces[currentPlayer.color]) do
            local square = game.board[piece.y][piece.x]
            local isHovered = M.square.is_hovered(square, x, y)
            hover = isHovered and true or hover
            piece:on_hover(isHovered)
        end
        return hover
    end,

    ---@param x number
    ---@param y number
    ---@param button number
    on_mouse_pressed = function(x, y, button)
        if not currentPlayer then return end
        if button == 2 then
            if not selectedPiece then return end
            selectedPiece:unselect()
            selectedPiece = nil
            return
        end
        if selectedPiece then
            local currentSquare = game.board[selectedPiece.y][selectedPiece.x]
            local square = M.board.get_hovered_square(game.board, x, y)
            local opponentKing = M.players.get_opponent_king(currentPlayer, game.pieces)
            local kingSquare = game.board[opponentKing.y][opponentKing.x]
            if square and not (square == kingSquare) then
                if selectedPiece.type == "pawn" then
                    if selectedPiece:can_promote(square) then
                        local newQueen = pieces["queen"]:new(square.gridPos.x, square.gridPos.y, selectedPiece.color)
                        table.delete(game.pieces[selectedPiece.color], selectedPiece)
                        table.insert(game.pieces[selectedPiece.color], newQueen)
                        local deadPiece = square.piece
                        if deadPiece then
                            M.square.free(square)
                            table.delete(game.pieces[deadPiece.color], deadPiece)
                        end
                        M.square.free(currentSquare)
                        M.square.occupy(square, newQueen)
                        if validate_turn(game) then
                            selectedPiece = nil
                            currentPlayer = M.players.next(currentPlayer)
                            M.players.set_last_piece(newQueen)
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
                        local deadPawn = selectedPiece:en_passant(square, game.board)
                        if deadPawn then
                            local deadPawnSquare = game.board[deadPawn.y][deadPawn.x]
                            table.delete(game.pieces[deadPawn.color], deadPawn)
                            M.square.free(currentSquare)
                            M.square.free(deadPawnSquare)
                            M.square.occupy(square, selectedPiece)
                            selectedPiece:move(square)
                            if validate_turn(game) then
                                selectedPiece:unselect()
                                selectedPiece = nil
                                currentPlayer = M.players.next(currentPlayer)
                                return
                            end
                            selectedPiece:move(currentSquare)
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
                    selectedPiece:move(castlingMovement.intermediate)
                    M.players.inspect_check(selectedPiece, game.pieces, game.board)
                    M.square.free(castlingMovement.intermediate)
                    M.square.occupy(currentSquare, selectedPiece)
                    if currentPlayer.check then
                        selectedPiece:move(currentSquare)
                        selectedPiece.hasMoved = false
                        return
                    end
                    M.square.occupy(square, selectedPiece)
                    M.square.occupy(castlingMovement.newPos, castlingMovement.tower)
                    M.square.free(currentSquare)
                    M.square.free(castlingMovement.lastPos)
                    selectedPiece:move(square)
                    castlingMovement.tower:move(castlingMovement.newPos)
                    if validate_turn(game) then
                        selectedPiece:unselect()
                        selectedPiece = nil
                        currentPlayer = M.players.next(currentPlayer)
                        return
                    end
                    selectedPiece.hasMoved = false
                    selectedPiece:move(currentSquare)
                    castlingMovement.tower.hasMoved = false
                    castlingMovement.tower:move(castlingMovement.lastPos)
                    M.square.free(square)
                    M.square.occupy(currentSquare, selectedPiece)
                    M.square.free(castlingMovement.newPos)
                    M.square.occupy(castlingMovement.lastPos, castlingMovement.tower)
                    return
                end
                if selectedPiece:can_move(square, game.board) then
                    local deadPiece = square.piece
                    if deadPiece then
                        table.delete(game.pieces[square.piece.color], deadPiece)
                    end
                    M.square.free(currentSquare)
                    M.square.occupy(square, selectedPiece)
                    selectedPiece:move(square)
                    if validate_turn(game) then
                        selectedPiece:unselect()
                        selectedPiece = nil
                        currentPlayer = M.players.next(currentPlayer)
                        return
                    end
                    selectedPiece:move(currentSquare)
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
        for _, piece in ipairs(game.pieces[currentPlayer.color]) do
            if piece:on_mouse_pressed() then
                if selectedPiece then
                    selectedPiece:unselect()
                end
                selectedPiece = piece
                return
            end
        end
    end,

    draw = function()
        if not currentPlayer then return end
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
