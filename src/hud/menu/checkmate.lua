---@type Modules
local M = import "modules"

---@param windowW number
---@param windowH number
return function(windowW, windowH)
    local font = M.font.get_font(30)
    local labelText = "CHECKMATE!"
    local quitText = "QUIT"
    local quitW = font:getWidth(quitText)
    local charW, charH = M.font.get_text_dimensions(font, "0")

    return {
        widgets = {
            M.panel:new(windowW / 2, windowH / 2, windowW / 2, windowH / 2),
            M.label:new(windowW / 2, windowH / 2 - charH * 2, labelText, 40),
            M.button:new(windowW / 2 - quitW / 2 - charW / 2, windowH / 2, quitW + charW, charH, quitText, 30,
                function()
                    M.game.release()
                    M.hud.push_menu("connection")
                end),
        }
    }
end
