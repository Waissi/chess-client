---@type Modules
local M = import "modules"

return function()
    return {
        buttons = {
            M.button.new(0, 0, 100, 100, "WHITE", function() M.game.init("white") end),
            M.button.new(0, 150, 100, 100, "BLACK", function() M.game.init("black") end),
        }
    }
end
