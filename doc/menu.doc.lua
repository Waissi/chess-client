---@class MenuModule
---@field init fun(name: string, windowW: number, windowH: number): Menu
---@field on_mouse_moved fun(menu: Menu, x: number, y: number): boolean
---@field on_mouse_pressed fun(menu: Menu, x: number, y: number): boolean
---@field on_key_pressed fun(menu: Menu, key: string): boolean
---@field on_text_input fun(menu: Menu, char: string)
---@field draw fun(menu: Menu)

---@class Menu
---@field widgets Widget[]
