---@type Modules
local M = import "modules"

---@type string
local currentMenu

---@type Menu[]
local menus
return {
    init = function()
        local width, height = M.window.get_dimensions()
        menus = {
            start = M.menu.init("start", width, height),
            connection = M.menu.init("connection", width, height),
            game = M.menu.init("game", width, height),
            client = M.menu.init("client", width, height),
            userName = M.menu.init("userName", width, height),
            threefold = M.menu.init("threefold", width, height),
            fivefold = M.menu.init("fivefold", width, height),
            checkmate = M.menu.init("checkmate", width, height)
        }
        local userName = M.readwrite.get_user_name()
        currentMenu = userName and "connection" or "userName"
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

    ---@param x number
    ---@param y number
    ---@param button number
    on_mouse_pressed = function(x, y, button)
        if not (button == 1) then return end
        return M.menu.on_mouse_pressed(menus[currentMenu], x, y)
    end,

    ---@param key string
    on_key_pressed = function(key)
        return M.menu.on_key_pressed(menus[currentMenu], key)
    end,

    draw = function()
        M.menu.draw(menus[currentMenu])
    end
}
