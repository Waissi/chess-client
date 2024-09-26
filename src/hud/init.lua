---@type Modules
local M = import "modules"

local currentMenu = "connection"

return {
    init = function()
        return {
            menus = {
                start = M.menu.init("start"),
                connection = M.menu.init("connection"),
                game = M.menu.init("game")
            }
        }
    end,

    ---@param name string
    push_menu = function(name)
        currentMenu = name
    end,

    ---@param hud Hud
    ---@param x number
    ---@param y number
    on_mouse_moved = function(hud, x, y)
        return M.menu.on_mouse_moved(hud.menus[currentMenu], x, y)
    end,

    ---@param hud Hud
    ---@param button Button
    on_mouse_pressed = function(hud, button)
        if not (button == 1) then return end
        return M.menu.on_mouse_pressed(hud.menus[currentMenu])
    end,

    ---@param hud Hud
    draw = function(hud)
        M.menu.draw(hud.menus[currentMenu])
    end
}
