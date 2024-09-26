---@diagnostic disable: missing-parameter
local letters = { "A", "B", "C", "D", "E", "F", "G", "H" }

local font = love.graphics.newFont(20)
love.graphics.setDefaultFilter("nearest")
love.graphics.setFont(font)
local letterW, letterH = font:getWidth("0"), font:getHeight("0")
local hostColor

return {
    ---@param color string
    init = function(color)
        hostColor = color
    end,

    ---@param index number
    get_letter = function(index)
        return letters[index]
    end,

    ---@param letter string
    get_index = function(letter)
        for key, value in ipairs(letters) do
            if value == letter then
                return key
            end
        end
    end,

    ---@param screenW number
    ---@param screenH number
    ---@param squareW number
    ---@param squareH number
    ---@param columnW number
    draw = function(screenW, screenH, squareW, squareH, columnW)
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
