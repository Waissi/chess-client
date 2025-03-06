io.stdout:setvbuf('no')
if arg[#arg] == "debug" then
    require("lldebugger").start()
end

local gameName = "Chess"

function love.conf(t)
    t.identity = gameName
    t.window.title = gameName
    t.window.width = 850
    t.window.height = 850
    t.window.icon = "icon.png"
end
