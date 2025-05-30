---@type Modules
local M = import "modules"

local columnW = 25
local beige = { .75, .7, .6 }
local brown = { .25, .2, .2 }
local width, height, squareW, squareH

return {
    new = function()
        width, height = M.window.get_dimensions()
        squareW, squareH = (width - columnW * 2) / 8, (height - columnW * 2) / 8
        local grid = {}
        for j = 1, 8 do
            grid[j] = {}
            for i = 1, 8 do
                local x = columnW + (i - 1) * squareW
                local y = columnW + (j - 1) * squareH
                local squareColor = (i + j) % 2 == 0 and beige or brown
                grid[j][i] = M.square.new(x, y, squareW, squareH, { x = i, y = j }, squareColor)
            end
        end
        return grid
    end,

    ---@param board Square[][]
    ---@param x number
    ---@param y number
    ---@param mouseX number
    ---@param mouseY number
    is_square_hovered = function(board, x, y, mouseX, mouseY)
        local square = board[y][x]
        return M.square.is_hovered(square, mouseX, mouseY)
    end,

    ---@param board Square[][]
    ---@param x number
    ---@param y number
    get_hovered_square = function(board, x, y)
        for j = 1, 8 do
            for i = 1, 8 do
                local square = board[j][i]
                if M.square.is_hovered(square, x, y) then
                    return square
                end
            end
        end
    end,

    ---@param board Square[][]
    draw = function(board)
        for j = 1, 8 do
            for i = 1, 8 do
                M.square.draw(board[j][i])
            end
        end
        M.coordinates.draw(width, height, squareW, squareH, columnW)
    end
}
