---@type Modules
local M = import "modules"

---@param windowW number
---@param windowH number
return function(windowW, windowH)
    local buttonW, buttonH = windowW / 4, windowH / 10
    return {
        widgets = {
            M.button:new(windowW / 2 - buttonW / 2, windowH / 2 - buttonH / 2, buttonW, buttonH, "CONNECT", 20,
                function()
                    if M.connection.init() then
                        M.hud.push_menu("waitingRoom")
                    end
                end)
        }
    }
end
