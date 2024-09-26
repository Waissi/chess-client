---@class PlayerModule
---@field init fun(color: string): Player
---@field next fun(currentPlayer: Player): Player
---@field set_last_piece fun(piece: Piece)
---@field get_last_piece_played fun(): Piece
---@field set_en_passant fun(color: string, bool: boolean)
---@field can_perform_en_passant fun(currentPlayer: Player): boolean
---@field get_current_player_king fun(currentPlayer: Player, pieces: Piece[]): Piece
---@field get_opponent_king fun(currentPlayer: Player, pieces: Piece[]): Piece
---@field inspect_check fun(king: Piece, pieces: Piece[], board: Square[][])
---@field can_perform_castling fun(king: Piece, square: Square, board: Square[][]): boolean, CastlingMovement

---@class Player
---@field color string
---@field check boolean
---@field hasMoved boolean
---@field enPassantVulnerable boolean

---@class CastlingMovement
---@field tower Piece
---@field newPos Square
---@field lastPos Square
---@field intermediate Square