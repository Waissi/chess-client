---@class HudModule
---@field init fun(): Hud
---@field push_menu fun(name: string)
---@field on_mouse_moved fun(hud: Hud, x: number, y: number): boolean
---@field on_mouse_pressed fun(hud: Hud, button: number): boolean
---@field draw fun(hud: Hud)

---@class Hud
---@field menus Menu[]
