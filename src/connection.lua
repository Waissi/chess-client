---@type Modules
local M = import "modules"

local enet = require "enet"
local json = import "json"
local host = enet.host_create()
local https = require "https"
local url = "https://qfigqmeles6mwpsyxoi2tbq52e0xwiul.lambda-url.eu-central-1.on.aws/"
local userId = os.time()
local server
local serverChannels = {
    ["player_input"] = 1,
    ["new"] = 2
}

---@type fun(channel: number, data: string)
local handle_event = {
    ---@param color string
    function(color)
        M.game.init(color)
    end,

    ---@param data table
    function(data)
        local pieces = json.decode(data)
        M.game.start(pieces)
    end,

    ---@param update table
    function(update)
        local data = json.decode(update)
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
        if os.getenv("env") == "dev" then
            server = host:connect("localhost:6789", 5, userId)
            print("Connecting with local server: ", server)
            return true
        end
        local status, address = https.request(url, { data = "server" })
        if status == 200 then
            server = host:connect(address .. ":6789", 5, userId)
            print("Connecting with remote server: ", server)
            return true
        end
    end,

    ---@param gameData table
    send_player_input = function(gameData)
        if not server then return end
        local data = json.encode(gameData)
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
