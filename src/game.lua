---@type Modules
local M = import "modules"

---@type Piece?
local selectedPiece

---@type string
local playerColor, currentPlayer

---@type Game?
local game

local startPos = {
    white = {
        [1] = {
            { type = "rook",   color = "black" },
            { type = "knight", color = "black" },
            { type = "bishop", color = "black" },
            { type = "queen",  color = "black" },
            { type = "king",   color = "black" },
            { type = "bishop", color = "black" },
            { type = "knight", color = "black" },
            { type = "rook",   color = "black" },
        },
        [2] = {
            { type = "pawn", color = "black" },
            { type = "pawn", color = "black" },
            { type = "pawn", color = "black" },
            { type = "pawn", color = "black" },
            { type = "pawn", color = "black" },
            { type = "pawn", color = "black" },
            { type = "pawn", color = "black" },
            { type = "pawn", color = "black" },
        },
        [7] = {
            { type = "pawn", color = "white" },
            { type = "pawn", color = "white" },
            { type = "pawn", color = "white" },
            { type = "pawn", color = "white" },
            { type = "pawn", color = "white" },
            { type = "pawn", color = "white" },
            { type = "pawn", color = "white" },
            { type = "pawn", color = "white" },
        },
        [8] = {
            { type = "rook",   color = "white" },
            { type = "knight", color = "white" },
            { type = "bishop", color = "white" },
            { type = "queen",  color = "white" },
            { type = "king",   color = "white" },
            { type = "bishop", color = "white" },
            { type = "knight", color = "white" },
            { type = "rook",   color = "white" },
        }
    },
    black = {
        [1] = {
            { type = "rook",   color = "white" },
            { type = "knight", color = "white" },
            { type = "bishop", color = "white" },
            { type = "king",   color = "white" },
            { type = "queen",  color = "white" },
            { type = "bishop", color = "white" },
            { type = "knight", color = "white" },
            { type = "rook",   color = "white" },
        },
        [2] = {
            { type = "pawn", color = "white" },
            { type = "pawn", color = "white" },
            { type = "pawn", color = "white" },
            { type = "pawn", color = "white" },
            { type = "pawn", color = "white" },
            { type = "pawn", color = "white" },
            { type = "pawn", color = "white" },
            { type = "pawn", color = "white" },
        },
        [7] = {
            { type = "pawn", color = "black" },
            { type = "pawn", color = "black" },
            { type = "pawn", color = "black" },
            { type = "pawn", color = "black" },
            { type = "pawn", color = "black" },
            { type = "pawn", color = "black" },
            { type = "pawn", color = "black" },
            { type = "pawn", color = "black" },
        },
        [8] = {
            { type = "rook",   color = "black" },
            { type = "knight", color = "black" },
            { type = "bishop", color = "black" },
            { type = "king",   color = "black" },
            { type = "queen",  color = "black" },
            { type = "bishop", color = "black" },
            { type = "knight", color = "black" },
            { type = "rook",   color = "black" },
        }
    }
}

local end_turn = function()
    M.piece.unselect(selectedPiece)
    selectedPiece = nil
    currentPlayer = currentPlayer == "white" and "black" or "white"
end

return {
    ---@param color string
    init = function(color)
        playerColor = color
        M.coordinates.init(playerColor)
        currentPlayer = "white"
        game = {
            board = M.board.new(),
            pieces = {
                white = {},
                black = {}
            }
        }
        local colorPos = startPos[playerColor]
        for number, list in pairs(colorPos) do
            for key, piece in ipairs(list) do
                local x = key
                local y = number
                table.insert(game.pieces[piece.color], M.piece.new(piece.type, x, y, piece.color))
            end
        end

        for _, colorPieces in pairs(game.pieces) do
            for _, piece in ipairs(colorPieces) do
                local square = game.board[piece.pos.y][piece.pos.x]
                M.square.occupy(square, piece)
            end
        end
        M.hud.pop_menu()
        return game
    end,

    get_opponent_color = function()
        return playerColor == "white" and "black" or "white"
    end,

    release = function()
        if not game then return end
        game = nil
    end,

    ---@param x number
    ---@param y number
    on_mouse_moved = function(x, y)
        if not game or not (currentPlayer == playerColor) then return end
        local hover = false
        for _, piece in ipairs(game.pieces[playerColor]) do
            local square = game.board[piece.pos.y][piece.pos.x]
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
        if not game or not (currentPlayer == playerColor) then return end
        if button == 2 then
            if not selectedPiece then return end
            M.piece.unselect(selectedPiece)
            selectedPiece = nil
            return
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

        if selectedPiece then
            local square = M.board.get_hovered_square(game.board, x, y)
            if not square then return end
            local posX, posY = M.coordinates.translate(selectedPiece.pos)
            local nextPosX, nextPosY = M.coordinates.translate(square.pos)
            M.connection.send_game_data(
                {
                    color = playerColor,
                    pos = { x = posX, y = posY },
                    nextPos = { x = nextPosX, y = nextPosY }
                }
            )
        end
    end,

    ---@param gameData table
    handle_update = function(gameData)
        if not game then return end
        local newX, newY = M.coordinates.translate(gameData.movedPiece.newPos)
        local newSquare = game.board[newY][newX]
        if newSquare.piece then
            table.delete(game.pieces[newSquare.piece.color], newSquare.piece)
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
            local diff = newSquare.pos.x - pieceSquare.pos.x
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
        local menu = gameData.menu
        if menu then
            if menu == "fivefold" then
                if currentPlayer == playerColor then
                    end_turn()
                end
                M.hud.push_menu(menu)
                return
            elseif menu == "checkmate" then
                if currentPlayer == playerColor then
                    end_turn()
                    M.hud.push_menu("victory")
                    return
                end
                M.hud.push_menu(menu)
                return
            elseif menu == "threefold" and not (currentPlayer == playerColor) then
                M.hud.push_menu(menu)
                return
            end
        end
        end_turn()
    end,

    continue_playing = function()
        end_turn()
    end,

    draw = function()
        if not game then return end
        M.board.draw(game.board)
        love.graphics.setColor(1, 1, 1, 1)
        for _, colorPieces in pairs(game.pieces) do
            for _, piece in ipairs(colorPieces) do
                local square = game.board[piece.pos.y][piece.pos.x]
                love.graphics.draw(piece.img, square.drawPos.x, square.drawPos.y)
            end
        end
        if selectedPiece then
            local square = game.board[selectedPiece.pos.y][selectedPiece.pos.x]
            M.square.draw_selected(square)
        end
    end
}
