---@type Modules
local M = import "modules"

---@param windowW number
---@param windowH number
return function(windowW, windowH)
    local buttonW, buttonH = windowW / 4, windowH / 10
    return {
        widgets = {
            M.button:new(windowW / 4 - buttonW / 2, windowH / 2 - buttonH / 2, buttonW, buttonH, "HOST", 20,
                function() M.connection.init_host() end),
            M.button:new(windowW * 3 / 4 - buttonW / 2, windowH / 2 - buttonH / 2, buttonW, buttonH, "JOIN", 20,
                function() M.hud.push_menu("client") end),
        }
    }
end
