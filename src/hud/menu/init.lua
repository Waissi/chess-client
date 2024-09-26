---@type Modules
local M = import "modules"

local menus = {
    start = import "startMenu",
    connection = import "connectionMenu",
    game = import "gameMenu"
}

return {

    ---@param name string
    init = function(name)
        return menus[name]()
    end,

    ---@param menu Menu
    ---@param x number
    ---@param y number
    on_mouse_moved = function(menu, x, y)
        local hover = false
        for _, menuButton in ipairs(menu.buttons) do
            if M.button.on_mouse_moved(menuButton, x, y) then
                hover = true
            end
        end
        return hover
    end,

    ---@param menu Menu
    on_mouse_pressed = function(menu)
        for _, menuButton in ipairs(menu.buttons) do
            if M.button.on_mouse_pressed(menuButton) then return true end
        end
    end,

    ---@param menu Menu
    draw = function(menu)
        for _, menuButton in ipairs(menu.buttons) do
            M.button.draw(menuButton)
        end
    end
}
