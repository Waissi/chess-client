---@type Modules
local M = import "modules"

local socket = require "socket"
local enet = require "enet"
local json = import "json"
local role, host, peer

---@type fun(name: string): string?
local get_connection_key = function(name)
    local savedConnections = M.readwrite.get_saved_connections()
    for _, connection in ipairs(savedConnections) do
        if connection.name == name then
            return connection.key
        end
    end
end

---@param username string
local confirm_connection = function(username)
    local buttons = { "ACCEPT", "REFUSE" }
    local pressedButton = love.window.showMessageBox("CONNECTION REQUEST", "Confirm connection with: " .. username,
        buttons)
    if pressedButton == 2 then return end
    M.hud.push_menu("start")
    return true
end

---@type fun(eventMessage: string, event: table, data: table)
local handle_event = switch {
    ---@param event table
    ---@param data table
    ["init"] = function(event, data)
        peer = event.peer
        M.game.init(data.color)
    end,

    ---@param event table
    ["get_username"] = function(event)
        local usernameData = json.encode({ message = "set_username", username = M.readwrite.get_user_name() })
        event.peer:send(usernameData)
    end,

    ---@param event table
    ---@param data table
    ["set_username"] = function(event, data)
        if confirm_connection(data.username) then
            peer = event.peer
        end
    end,

    ---@param data table
    ["gamedata"] = function(_, data)
        M.game.receive_game_data(data.data)
    end,

    ["quit"] = function()
        peer = nil
        M.game.release()
    end,
}

return {
    init_host = function()
        if not host then
            local ip = socket.dns.toip(socket.dns.gethostname())
            socket.bind(ip, 6789)
            role = "host"
            host = enet.host_create(ip .. ":6789")
            local encoded = love.data.encode("string", "base64", ip)
            ---@cast encoded string
            love.window.showMessageBox(encoded, "Share this key with your game partner", "info", true)
            return
        end
        local ip = socket.dns.toip(socket.dns.gethostname())
        local encoded = love.data.encode("string", "base64", ip)
        ---@cast encoded string
        love.window.showMessageBox(encoded, "Share this key with your game partner", "info", true)
    end,

    ---@param connectionData ConnectionData
    init_client = function(connectionData)
        if not connectionData then return end
        role = "client"
        local key = connectionData.key or get_connection_key(connectionData.name)
        if not key then return end
        local ip = love.data.decode("string", "base64", key)
        if not (socket.dns.toip(ip)) then return end
        host = enet.host_create()
        if not host:connect(ip .. ":6789") then
            host:destroy()
            host = nil
        end
        if not connectionData.key then return end
        M.readwrite.save_connection(connectionData)
    end,

    ---@param gameData table
    send_game_data = function(gameData)
        if not peer then return end
        local data = json.encode({ data = gameData, message = "gamedata" })
        peer:send(data)
        host:service()
    end,

    ---@param color string
    start_game = function(color)
        if not (role == "host") then return end
        local data = json.encode({ color = color, message = "init" })
        peer:send(data)
        host:service()
    end,

    end_game = function()
        if not host or not peer then return end
        local data = json.encode({ message = "quit" })
        peer:send(data)
        host:service()
        host:destroy()
    end,

    update = function()
        if not host then return end
        local event = host:service()
        if event then
            if event.type == "connect" then
                if role == "host" then
                    local data = json.encode({ message = "get_username" })
                    event.peer:send(data)
                end
            elseif event.type == "disconnect" then
                peer = nil
                M.game.release()
                return
            elseif event.type == "receive" then
                local data = json.decode(event.data)
                handle_event(data.message, event, data)
            end
            host:service()
        end
    end
}
