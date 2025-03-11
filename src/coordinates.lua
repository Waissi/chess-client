---@type Modules
local M = import "modules"
local letters = { "A", "B", "C", "D", "E", "F", "G", "H" }

local translation = { 8, 7, 6, 5, 4, 3, 2, 1 }

local font = M.font.get_font(20)
local letterW, letterH = M.font.get_text_dimensions(font, "0")

---@type string
local hostColor

return {
    ---@param color string
    init = function(color)
        hostColor = color
    end,

    ---@param x number
    ---@param y number
    translate = function(x, y)
        if hostColor == "white" then return x, y end
        return translation[x], translation[y]
    end,

    ---@param screenW number
    ---@param screenH number
    ---@param squareW number
    ---@param squareH number
    ---@param columnW number
    draw = function(screenW, screenH, squareW, squareH, columnW)
        love.graphics.setFont(font)
        if hostColor == "white" then
            love.graphics.setColor(0, 0, 0)
            for i = 1, 8 do
                love.graphics.print(tostring(i), math.floor(columnW / 2 - letterW / 2),
                    math.floor(screenH - columnW - (i - 1) * squareH - squareH / 2 - letterH / 2))
                love.graphics.print(letters[i], math.floor(columnW + (i - 1) * squareW + squareW / 2 - letterW / 2),
                    math.floor(screenH - columnW))
            end
            love.graphics.setColor(1, 1, 1)
            return
        end
        love.graphics.setColor(0, 0, 0)
        for i = 1, 8 do
            love.graphics.print(tostring(i), math.floor(columnW / 2 - letterW / 2),
                math.floor(columnW + i * squareH - squareH / 2 - letterH / 2))
            love.graphics.print(letters[i], math.floor(screenW - columnW - i * squareW + squareW / 2 - letterW / 2),
                math.floor(screenH - columnW))
        end
        love.graphics.setColor(1, 1, 1)
    end
}
