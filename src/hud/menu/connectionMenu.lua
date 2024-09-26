---@type Modules
local M = import "modules"

return function()
    return {
        buttons = {
            M.button.new(0, 0, 100, 100, "HOST", function() M.connection.init("host") end),
            M.button.new(0, 150, 100, 100, "JOIN", function() M.connection.init("client") end),
        }
    }
end
