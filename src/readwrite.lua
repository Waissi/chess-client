local json = import "json"
local userFile = "settings.txt"
local connectionsFile = "savedconnections.txt"
local savedConnections
local settings

---@param newConnection ConnectionData
local is_known_connection = function(newConnection)
    for _, connection in ipairs(savedConnections) do
        if connection.key == newConnection.key and
            connection.name == newConnection.name then
            return true
        end
    end
end

return {
    get_user_name = function()
        if not love.filesystem.getInfo(userFile, "file") then return end
        local file = love.filesystem.read(userFile)
        settings = json.decode(file)
        return settings.userName
    end,

    ---@param userName string
    set_user_name = function(userName)
        settings = settings or {}
        settings.userName = userName
        local file = json.encode(settings)
        love.filesystem.write(userFile, file)
    end,

    get_saved_connections = function()
        if not love.filesystem.getInfo(connectionsFile, "file") then return {} end
        if savedConnections then return savedConnections end
        local file = love.filesystem.read(connectionsFile)
        savedConnections = json.decode(file)
        return savedConnections
    end,

    ---@param newConnection ConnectionData
    save_connection = function(newConnection)
        savedConnections = savedConnections or {}
        if is_known_connection(newConnection) then return end
        savedConnections[#savedConnections + 1] = newConnection
        local file = json.encode(savedConnections)
        love.filesystem.write(connectionsFile, file)
    end
}
