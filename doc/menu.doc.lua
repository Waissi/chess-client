---@class MenuModule
---@field init fun(): Menu
---@field on_mouse_moved fun(menu: Menu, x: number, y: number): boolean
---@field on_mouse_pressed fun(menu: Menu): boolean
---@field draw fun(menu: Menu)

---@class Menu
---@field buttons Button[]
