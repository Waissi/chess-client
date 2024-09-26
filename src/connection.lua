local enet = require "enet"
local testRole, host, peer
--[[
    local socket = require("socket")
    -- create a TCP socket and bind it to the local host, at any port
    local server = assert(socket.bind("*", 0))
    -- find out which port the OS chose for us
    local ip = socket.dns.toip(socket.dns.gethostname())
    print(ip)

    local enet = require "enet"
    local host = enet.host_create(ip..":100")
    print(host:get_socket_address())
    ]]

return {
    init = function(role)
        if role == "host" then
            testRole = role
            host = enet.host_create("localhost:6789")
            return
        end
        host = enet.host_create()
        local server = host:connect("localhost:6789")
    end,

    test = function()
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
            elseif event.type == "disconnect" then
                host:destroy()
                love.event.quit()
            elseif event.type == "receive" then
                print(event.data)
            end
        end
        event = host:service()
    end,

    disconnect = function()
        host:destroy()
        print "disconnect"
    end
}
