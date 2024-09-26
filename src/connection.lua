local enet = require "enet"
local testRole, host, peer

return {
    init = function(role)
        local socket = require("socket")
        -- create a TCP socket and bind it to the local host, at any port
        local _server = assert(socket.bind("*", 0))
        -- find out which port the OS chose for us
        local ip = socket.dns.toip(socket.dns.gethostname())
        print(ip)
        if role == "host" then
            testRole = role
            --host = enet.host_create(ip .. ":6789")
            host = enet.host_create("*:6789")
            print(host:get_socket_address())
            return
        end
        host = enet.host_create()
        --local server = host:connect(ip .. ":6789")
        local server = host:connect("*:6789")
        print(server)
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
                print "peer connected"
            elseif event.type == "disconnect" then
                host:destroy()
                print "peer disconnected"
                love.event.quit()
            elseif event.type == "receive" then
                print(event.data)
            end
        end
        event = host:service()
    end,

    disconnect = function()
        if not host then return end
        host:destroy()
        print "host disconnect"
    end
}
