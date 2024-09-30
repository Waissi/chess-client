---@class HudModule
---@field init fun()
---@field push_menu fun(name: string)
---@field on_mouse_moved fun(x: number, y: number): boolean
---@field on_mouse_pressed fun(x: number, y: number, button: number): boolean
---@field on_key_pressed fun(key: string): boolean
---@field on_text_input fun(char: string)
---@field draw fun()
