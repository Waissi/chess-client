---@class SquareModule
---@field new fun(x: number, y: number, w: number, h: number, gridPos: Position, color: table): Square
---@field occupy fun(square: Square, piece: Piece)
---@field free fun(square: Square)
---@field is_hovered fun(square: Square, x: number, y: number): boolean
---@field draw fun(square: Square)
---@field draw_selected fun(square: Square)

---@class Square
---@field x number
---@field y number
---@field w number
---@field h number
---@field gridPos Position
---@field color table
---@field piece Piece?

---@class Position
---@field x number
---@field y number
