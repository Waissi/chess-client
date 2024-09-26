---@type Modules
local M = import "modules"

local currentMenu = "connection"

---@type Menu[]
local menus
return {
    init = function()
        menus = {
            start = M.menu.init("start"),
            connection = M.menu.init("connection"),
            game = M.menu.init("game"),
            client = M.menu.init("client")
        }
    end,

    ---@param name string
    push_menu = function(name)
        currentMenu = name
    end,

    ---@param x number
    ---@param y number
    on_mouse_moved = function(x, y)
        return M.menu.on_mouse_moved(menus[currentMenu], x, y)
    end,

    ---@param char string
    on_text_input = function(char)
        M.menu.on_text_input(menus[currentMenu], char)
    end,

    ---@param button number
    on_mouse_pressed = function(button)
        if not (button == 1) then return end
        return M.menu.on_mouse_pressed(menus[currentMenu])
    end,

    ---@param key string
    on_key_pressed = function(key)
        return M.menu.on_key_pressed(menus[currentMenu], key)
    end,

    draw = function()
        M.menu.draw(menus[currentMenu])
    end
}
