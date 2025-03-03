---@type Modules
local M = import "modules"

local enet = require "enet"
local json = import "json"
local host = enet.host_create()
local server

---@type fun(eventMessage: string, data: table)
local handle_event = switch {
    ---@param data table
    ["init"] = function(data)
        M.game.init(data.color)
    end,

    ["release"] = function()
        M.game.release()
        M.hud.push_menu("connection")
        server = nil
    end,

    ---@param data table
    ["game_update"] = function(data)
        M.game.handle_update(data.gameData)
    end
}

return {
    init = function()
        if server then return end
        server = host:connect("3.70.227.137:6789")
    end,

    ---@param gameData table
    send_game_data = function(gameData)
        if not server then return end
        local data = json.encode({ data = gameData, message = "player_turn" })
        server:send(data)
        host:service()
    end,

    ---@param previousColor string
    ---@param newColor string
    start_game = function(previousColor, newColor)
        local data = json.encode(
            {
                message = "init",
                data = {
                    previousColor = previousColor,
                    newColor = newColor
                }
            }
        )
        server:send(data)
        host:service()
    end,

    new_game = function()
        local data = json.encode({ message = "new" })
        server:send(data)
        host:service()
    end,

    end_game = function()
        if not server then return end
        local data = json.encode({ message = "quit" })
        server:send(data)
        host:service()
        host:destroy()
    end,

    update = function()
        if not server then return end
        local event = host:service()
        if event and event.type == "receive" then
            local data = json.decode(event.data)
            handle_event(data.message, data)
            host:service()
        end
    end
}
