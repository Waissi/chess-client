---@type Modules
local M = import "modules"

return function()
    return {
        widgets = {
            M.button:new(0, 0, 100, 100, "HOST", function() M.connection.init_host() end),
            M.button:new(0, 150, 100, 100, "JOIN", function() M.hud.push_menu("client") end),
        }
    }
end
