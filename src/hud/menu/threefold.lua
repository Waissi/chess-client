---@type Modules
local M = import "modules"

---@param windowW number
---@param windowH number
return function(windowW, windowH)
    local font = M.font.get_font(30)
    local labelText = "THREEFOLD REPETITION!"
    local continueText = "CONTINUE"
    local drawText = "CLAIM DRAW"
    local charH = font:getHeight("0")
    local continueW = font:getWidth(continueText)
    local drawW = font:getWidth(drawText)

    return {
        widgets = {
            M.panel:new(windowW / 2, windowH / 2, windowW / 2, windowH / 2),
            M.label:new(windowW / 2, windowH / 2 - charH * 2, labelText, 30),
            M.button:new(windowW / 2 - drawW / 2, windowH / 2, drawW, charH, drawText, 30,
                function()
                    M.game.release()
                    M.hud.push_menu("start")
                end),
            M.button:new(windowW / 2 - continueW / 2, windowH / 2 + charH * 2, continueW, charH, continueText, 30,
                function()
                    M.game.continue_playing()
                    M.hud.push_menu("game")
                end),
        }
    }
end
