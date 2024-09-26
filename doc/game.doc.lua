---@class GameModule
---@field init fun()
---@field on_mouse_moved fun(x: number, y: number): boolean
---@field on_mouse_pressed fun(x: number, y: number, button: number)
---@field draw fun()

---@class Game
---@field board Square[][]
---@field pieces table<string, Piece[]>
