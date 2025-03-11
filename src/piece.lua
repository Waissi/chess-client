local images = {
    ["black"] = {
        ["bishop"] = love.graphics.newImage("assets/black/bishop.png"),
        ["king"] = love.graphics.newImage("assets/black/king.png"),
        ["knight"] = love.graphics.newImage("assets/black/knight.png"),
        ["pawn"] = love.graphics.newImage("assets/black/pawn.png"),
        ["queen"] = love.graphics.newImage("assets/black/queen.png"),
        ["rook"] = love.graphics.newImage("assets/black/rook.png"),
    },
    ["white"] = {
        ["bishop"] = love.graphics.newImage("assets/white/bishop.png"),
        ["king"] = love.graphics.newImage("assets/white/king.png"),
        ["knight"] = love.graphics.newImage("assets/white/knight.png"),
        ["pawn"] = love.graphics.newImage("assets/white/pawn.png"),
        ["queen"] = love.graphics.newImage("assets/white/queen.png"),
        ["rook"] = love.graphics.newImage("assets/white/rook.png"),
    }
}

return {
    ---@param color string
    ---@param type string
    ---@param x number
    ---@param y number
    draw = function(color, type, x, y)
        local texture = images[color][type]
        love.graphics.draw(texture, x, y)
    end
}
