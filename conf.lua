io.stdout:setvbuf('no')

local gameName = "Chess"

function love.conf(t)
    t.identity = gameName
    t.window.title = gameName
    t.window.width = 850
    t.window.height = 850
    t.window.icon = "assets/icon.png"
end
