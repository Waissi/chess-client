---@type Modules
local M = import "modules"

---@type Square?
local selectedSquare

---@type string
local playerColor, currentPlayer

---@type Piece[][]?
local pieces

---@type Square[][]
local board = M.board.new()

return {
    ---@param color string
    init = function(color)
        playerColor = color
        M.coordinates.init(playerColor)
        currentPlayer = "white"
        M.hud.pop_menu()
    end,

    ---@param newPieces Piece[][]
    start = function(newPieces)
        pieces = newPieces
    end,

    release = function()
        currentPlayer = playerColor == "white" and "black" or "white"
    end,

    ---@param x number
    ---@param y number
    on_mouse_moved = function(x, y)
        if not pieces or not (currentPlayer == playerColor) then return end
        for _, piece in ipairs(pieces[playerColor]) do
            local posX, posY = M.coordinates.translate(piece.x, piece.y)
            if M.board.is_square_hovered(board, posX, posY, x, y) then
                return true
            end
        end
    end,

    ---@param x number
    ---@param y number
    ---@param button number
    on_mouse_pressed = function(x, y, button)
        if not pieces or not (currentPlayer == playerColor) then return end
        if button == 2 then
            if not selectedSquare then return end
            selectedSquare = nil
            return
        end
        local square = M.board.get_hovered_square(board, x, y)
        if not square then
            selectedSquare = nil
            return
        end
        if square == selectedSquare then return end
        for _, piece in ipairs(pieces[playerColor]) do
            local posX, posY = M.coordinates.translate(piece.x, piece.y)
            if posX == square.pos.x and posY == square.pos.y then
                selectedSquare = square
                return
            end
        end
        if not selectedSquare then return end
        local posX, posY = M.coordinates.translate(selectedSquare.pos.x, selectedSquare.pos.y)
        local nextX, nextY = M.coordinates.translate(square.pos.x, square.pos.y)
        M.connection.send_player_input(
            {
                color = playerColor,
                pos = { x = posX, y = posY },
                nextPos = { x = nextX, y = nextY }
            }
        )
    end,

    ---@param data table
    update = function(data)
        selectedSquare = nil
        pieces = data.pieces
        local menu = data.menu
        if menu then
            if menu == "fivefold" then
                if currentPlayer == playerColor then
                    currentPlayer = currentPlayer == "white" and "black" or "white"
                end
                M.hud.push_menu(menu)
                return
            elseif menu == "checkmate" then
                if currentPlayer == playerColor then
                    currentPlayer = currentPlayer == "white" and "black" or "white"
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
        currentPlayer = currentPlayer == "white" and "black" or "white"
    end,

    continue_playing = function()
        currentPlayer = currentPlayer == "white" and "black" or "white"
    end,

    draw = function()
        if not pieces then return end
        M.board.draw(board)
        love.graphics.setColor(1, 1, 1, 1)
        for _, color in pairs(pieces) do
            for _, piece in ipairs(color) do
                local posX, posY = M.coordinates.translate(piece.x, piece.y)
                local square = board[posY][posX]
                M.piece.draw(piece.color, piece.type, square.drawPos.x, square.drawPos.y)
            end
        end
        if selectedSquare then
            local square = board[selectedSquare.pos.y][selectedSquare.pos.x]
            M.square.draw_selected(square)
        end
    end
}
