---@type Modules
local M = import "modules"

return function()
    return {
        widgets = {
            M.label:new(100, 100, "ENTER THE PASSKEY SHARED BY THE HOST AND PRESS ENTER"),
            M.inputBox:new(100, 300, 400, 200, function(inputText)
                if M.connection.init_client(inputText) then
                    print "inputText works"
                end
            end),
            M.button:new(100, 500, 200, 50, "CONNECT", function() end)
        }
    }
end
