require "src.import"
import "switch"
import "table"

---@type Modules
local M = import "modules"
local beige = { .75, .7, .6 }

local arrow = love.mouse.getSystemCursor("arrow")
local hand = love.mouse.getSystemCursor("hand")

function love.load()
    M.hud.init()
end

function love.update()
    M.connection.update()
end

function love.keypressed(key)
    if key == "p" then
        M.connection.send_game_data({})
    end
    return M.hud.on_key_pressed(key)
end

function love.textinput(char)
    M.hud.on_text_input(char)
end

function love.mousepressed(x, y, button)
    if M.hud.on_mouse_pressed(button) then return end
    M.game.on_mouse_pressed(x, y, button)
end

function love.mousemoved(x, y)
    local hover = false
    if M.hud.on_mouse_moved(x, y) or M.game.on_mouse_moved(x, y) then hover = true end
    love.mouse.setCursor(hover and hand or arrow)
end

function love.draw()
    love.graphics.clear(beige)
    M.game.draw()
    M.hud.draw()
end

function love.quit()
    M.connection.disconnect()
end
