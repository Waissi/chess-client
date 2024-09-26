---@type Modules
local M = import "modules"
local whiteImg = love.graphics.newImage("assets/w_rook.png")
local blackImg = love.graphics.newImage("assets/b_rook.png")

return setmetatable(
    {
        ---@param self PieceModule
        ---@param x number
        ---@param y number
        ---@param color string
        new = function(self, x, y, color)
            return setmetatable({
                    type = "rook",
                    state = "idle",
                    x = x,
                    y = y,
                    color = color,
                    img = color == "white" and whiteImg or blackImg,
                    hasMoved = false,
                },
                {
                    __index = self
                }
            )
        end,

    },
    { __index = M.interface }
)
