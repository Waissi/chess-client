---@type Modules
local M = import "modules"

local enet = require "enet"
local host = enet.host_create()
local server
local serverChannels = {
    ["player_input"] = 1,
    ["new"] = 2
}

local function serialize_table(data)
    local parsedData = {}
    for index, value in pairs(data) do
        if type(value) == "table" then
            value = serialize_table(value)
        elseif type(value) == "string" then
            value = table.concat({ '"', value, '"' })
        end
        if type(index) == "number" then
            parsedData[#parsedData + 1] = tostring(value)
            parsedData[#parsedData + 1] = ','
        else
            parsedData[#parsedData + 1] = index
            parsedData[#parsedData + 1] = '='
            parsedData[#parsedData + 1] = tostring(value)
            parsedData[#parsedData + 1] = ','
        end
    end
    table.remove(parsedData, #parsedData)
    table.insert(parsedData, 1, '{')
    table.insert(parsedData, '}')
    return table.concat(parsedData)
end

---@type fun(channel: number, data: string)
local handle_event = {
    ---@param color string
    function(color)
        M.game.init(color)
    end,

    ---@param data string
    function(data)
        assert(string.sub(data, 1, 1) == "{" and string.sub(data, #data, #data) == "}", "corrupt data")
        local pieces = loadstring("return" .. data)()
        M.game.start(pieces)
    end,

    ---@param update string
    function(update)
        assert(string.sub(update, 1, 1) == "{" and string.sub(update, #update, #update) == "}", "corrupt data")
        local data = loadstring("return" .. update)()
        M.game.update(data)
    end,

    function()
        M.game.release()
        M.hud.push_menu("waitingRoom")
    end
}

return {
    init = function()
        if server then return end
        if arg[#arg] == "dev" then
            server = host:connect("localhost:6789", 5)
            print("Connecting with local server: ", server)
            return true
        end
        server = host:connect("chess.konngames.com:6789", 5)
        print("Connecting with remote server: ", server)
        return true
    end,

    ---@param gameData table
    send_player_input = function(gameData)
        if not server then return end
        local data = serialize_table(gameData)
        server:send(data, serverChannels["player_input"])
        host:service()
    end,

    new_game = function()
        server:send("", serverChannels["new"])
        host:service()
    end,

    end_game = function()
        if not server then return end
        server:disconnect_now()
    end,

    update = function()
        if not server then return end
        local event = host:service()
        while event do
            if event.type == "receive" then
                handle_event[event.channel](event.data)
            end
            event = host:service()
        end
    end
}
