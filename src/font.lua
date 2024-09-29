---@diagnostic disable: missing-parameter
local fonts = {}

return {
    ---@param size number
    get_font = function(size)
        if fonts[size] then return fonts[size] end
        local newFont = love.graphics.newFont(size)
        newFont:setFilter("nearest")
        fonts[size] = newFont
        return newFont
    end,

    ---@param font love.Font
    ---@param text string
    get_text_dimensions = function(font, text)
        return font:getWidth(text), font:getHeight(text)
    end,
}
