---@class SquareModule
---@field new fun(x: number, y: number, w: number, h: number, pos: Position, color: table): Square
---@field is_hovered fun(square: Square, x: number, y: number): boolean
---@field draw fun(square: Square)
---@field draw_selected fun(square: Square)

---@class Square
---@field w number
---@field h number
---@field pos Position
---@field drawPos Position
---@field color table

---@class Position
---@field x number
---@field y number
