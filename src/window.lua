local width, height = love.graphics.getDimensions()
return {
    get_dimensions = function()
        return width, height
    end
}
