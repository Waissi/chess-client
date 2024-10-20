---@type Modules
local M = import "modules"

---@param windowW number
---@param windowH number
return function(windowW, windowH)
    local drawFont = M.font.get_font(40)
    local font = M.font.get_font(30)
    local drawText = "DRAW!"
    local labelText = "FIVEFOLD REPETITION"
    local newgameText = "NEW GAME"
    local quitText = "QUIT"
    local charH = font:getHeight("0")
    local drawW = drawFont:getWidth(drawText)
    local continueW = font:getWidth(newgameText)

    return {
        widgets = {
            M.panel:new(windowW / 2, windowH / 2, windowW / 2, windowH / 2),
            M.label:new(windowW / 2, windowH / 2 - charH * 4, drawText, 40),
            M.label:new(windowW / 2, windowH / 2 - charH * 2, labelText, 30),
            M.button:new(windowW / 2 - drawW / 2, windowH / 2, drawW, charH, quitText, 30,
                function()
                    love.event.quit()
                end),
            M.button:new(windowW / 2 - continueW / 2, windowH / 2 + charH * 2, continueW, charH, newgameText, 30,
                function()
                    M.game.release()
                    M.hud.pop_menu()
                    M.connection.new_game()
                end),
        }
    }
end
