---@type Modules
local M = import "modules"

local whiteImg = love.graphics.newImage("assets/w_bishop.png")
local blackImg = love.graphics.newImage("assets/b_bishop.png")

return setmetatable(
    {
        ---@param self PieceModule
        ---@param x number
        ---@param y number
        ---@param color string
        new = function(self, x, y, color)
            return setmetatable({
                    type = "bishop",
                    state = "idle",
                    x = x,
                    y = y,
                    color = color,
                    hasMoved = false,
                    img = color == "white" and whiteImg or blackImg,
                },
                {
                    __index = self
                }
            )
        end,

    },
    { __index = M.interface }
)
