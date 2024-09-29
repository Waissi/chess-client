---@type Modules
local M = import "modules"

---@param windowW number
---@param windowH number
return function(windowW, windowH)
    local buttonW, buttonH = windowW / 4, windowH / 10
    return {
        widgets = {
            M.label:new(windowW / 2, windowH / 3, "CHOOSE YOUR COLOR", 30),
            M.button:new(windowW / 4 - buttonW / 2, windowH / 2 - buttonH / 2, buttonW, buttonH, "WHITE", 20,
                function() M.game.init("white") end),
            M.button:new(windowW * 3 / 4 - buttonW / 2, windowH / 2 - buttonH / 2, buttonW, buttonH, "BLACK", 20,
                function() M.game.init("black") end),
        }
    }
end
