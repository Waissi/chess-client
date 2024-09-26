local menus = {
    start = import "startMenu",
    connection = import "connectionMenu",
    game = import "gameMenu",
    client = import "clientMenu"
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
        for _, widget in ipairs(menu.widgets) do
            if widget:on_mouse_moved(x, y) then
                hover = true
            end
        end
        return hover
    end,

    ---@param menu Menu
    ---@param char string
    on_text_input = function(menu, char)
        for _, widget in ipairs(menu.widgets) do
            if widget:on_text_input(char) then return end
        end
    end,

    ---@param menu Menu
    on_mouse_pressed = function(menu)
        for _, widget in ipairs(menu.widgets) do
            if widget:on_mouse_pressed() then return true end
        end
    end,

    ---@param menu Menu
    ---@param key string
    on_key_pressed = function(menu, key)
        for _, widget in ipairs(menu.widgets) do
            if widget:on_key_pressed(key) then return true end
        end
    end,

    ---@param menu Menu
    draw = function(menu)
        for _, widget in ipairs(menu.widgets) do
            widget:draw()
        end
    end
}
