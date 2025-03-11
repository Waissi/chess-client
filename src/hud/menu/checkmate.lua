---@type Modules
local M = import "modules"

---@param windowW number
---@param windowH number
return function(windowW, windowH)
    local font = M.font.get_font(30)
    local labelText = "CHECKMATE!"
    local quitText = "QUIT"
    local newGameText = "NEW GAME"
    local newGameW = font:getWidth(newGameText)
    local quitW = font:getWidth(quitText)
    local charW, charH = M.font.get_text_dimensions(font, "0")

    return {
        widgets = {
            M.panel:new(windowW / 2, windowH / 2, windowW / 2, windowH / 2),
            M.label:new(windowW / 2, windowH / 2 - charH * 2, labelText, 40),
            M.button:new(windowW / 2 - newGameW / 2, windowH / 2, newGameW + charW, charH, newGameText, 30,
                function()
                    M.game.release()
                    M.connection.new_game()
                    M.hud.push_menu("waitingRoom")
                end),
            M.button:new(windowW / 2 - quitW / 2 - charW / 2, windowH / 2 + charH * 2, quitW + charW, charH, quitText, 30,
                function()
                    love.event.quit()
                end),
        }
    }
end
