require "src.import"
import "switch"
import "table"

---@type Modules
local M = import "modules"

---@type Hud
local hud

local arrow = love.mouse.getSystemCursor("arrow")
local hand = love.mouse.getSystemCursor("hand")

function love.load()
    hud = M.hud.init()
end

function love.update()
    M.connection.update()
end

function love.keypressed(key)
    if key == "p" then
        M.connection.test()
    end
end

function love.mousepressed(x, y, button)
    if M.hud.on_mouse_pressed(hud, button) then return end
    M.game.on_mouse_pressed(x, y, button)
end

function love.mousemoved(x, y)
    local hover = false
    if M.hud.on_mouse_moved(hud, x, y) or M.game.on_mouse_moved(x, y) then hover = true end
    love.mouse.setCursor(hover and hand or arrow)
end

function love.draw()
    M.game.draw()
    M.hud.draw(hud)
end

function love.quit()
    M.connection.disconnect()
end
