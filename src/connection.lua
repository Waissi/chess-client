local enet = require "enet"
local testRole, host, peer

return {
    init_host = function()
        local socket = require("socket")
        assert(socket.bind("*", 6789))
        local ip = socket.dns.toip(socket.dns.gethostname())
        local encoded = love.data.encode("string", "base64", ip)
        ---@cast encoded string
        love.window.showMessageBox(encoded, "Share this key with your game partner", "info", true)
        testRole = "host"
        print(ip)
        host = enet.host_create(ip .. ":6789")
    end,

    init_client = function(key)
        local ip = love.data.decode("string", "base64", key)
        host = enet.host_create()
        local server = host:connect(ip .. ":6789")
        print(ip)
        return true
    end,

    ---@param data table
    send_game_data = function(data)
        if testRole == "host" then
            if peer then
                peer:send("test")
            end
        end
    end,

    update = function()
        if not host then return end
        local event = host:service()
        if event then
            if event.type == "connect" then
                peer = event.peer
                print "peer connected"
            elseif event.type == "disconnect" then
                host:destroy()
                love.event.quit()
                return
            elseif event.type == "receive" then
                print(event.data)
            end
        end
        event = host:service()
    end,

    disconnect = function()
        if not host then return end
        host:destroy()
    end
}
