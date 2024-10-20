---@type Modules
local M = import "modules"

---@param windowW number
---@param windowH number
return function(windowW, windowH)
    local victoryText = "VICTORY!"

    return {
        widgets = {
            M.panel:new(windowW / 2, windowH / 2, windowW / 2, windowH / 2),
            M.label:new(windowW / 2, windowH / 2, victoryText, 40)
        }
    }
end
