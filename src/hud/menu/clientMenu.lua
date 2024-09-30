---@type Modules
local M = import "modules"

---@param windowW number
---@param windowH number
return function(windowW, windowH)
    local savedConnections = M.readwrite.get_saved_connections()
    local font = M.font.get_font(20)
    local charW, charH = M.font.get_text_dimensions(font, '0')
    local passkeyW, passkeyH = charW * 20, charW * 2
    local connectText = "CONNECT"
    local connectW = font:getWidth(connectText)

    ---@type Widget[]
    local widgets = {}
    widgets[#widgets + 1] = M.label:new(windowW / 4, windowH / 2 - passkeyH * 3, "PASSKEY", 20)
    local passkey = M.inputBox:new(windowW / 4 - passkeyW / 2, windowH / 2 - passkeyH * 2, passkeyW, passkeyH, 20)
    widgets[#widgets + 1] = passkey
    widgets[#widgets + 1] = M.label:new(windowW / 4, windowH / 2, "NAME", 20)
    local name = M.inputBox:new(windowW / 4 - passkeyW / 2, windowH / 2 + passkeyH, passkeyW, passkeyH, 20)
    widgets[#widgets + 1] = name
    widgets[#widgets + 1] = M.button:new(windowW / 4 - (connectW / 2 + charW), windowH / 2 + passkeyH * 3,
        connectW + charW * 2, passkeyH, connectText, 20, function()
            local connectionName = name:get_value()
            local connectionKey = passkey:get_value()
            if not connectionName and connectionKey then return end
            M.connection.init_client({
                name = connectionName,
                key = connectionKey
            })
        end)
    widgets[#widgets + 1] = M.label:new(windowW * 3 / 4, windowH / 2 - passkeyH * 3, "SAVED CONNECTIONS", 20)


    local buttonW, buttonH = 0, 0
    for _, connectionData in ipairs(savedConnections) do
        local connectionW, connectionH = M.font.get_text_dimensions(font, connectionData.name)
        if connectionW > buttonW then buttonW = connectionW end
        if connectionH > buttonH then buttonH = connectionH end
    end
    for i, connectionData in ipairs(savedConnections) do
        widgets[#widgets + 1] = M.button:new(windowW * 3 / 4 - passkeyW / 2,
            windowH / 2 - passkeyH + (i - 1) * buttonH * 2,
            passkeyW, buttonH + charH / 2, connectionData.name, 20, function()
                M.connection.init_client({ name = connectionData.name })
            end
        )
    end
    return { widgets = widgets }
end
