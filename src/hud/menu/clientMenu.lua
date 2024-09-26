---@type Modules
local M = import "modules"

return function()
    return {
        widgets = {
            M.label:new(100, 100, "ENTER PASSKEY AND PRESS ENTER"),
            M.inputBox:new(100, 300, 400, 200, function(inputText)
                if M.connection.init_client(inputText) then
                    print "inputText works"
                end
            end),
        }
    }
end
