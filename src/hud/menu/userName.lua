---@type Modules
local M = import "modules"

---@param windowW number
---@param windowH number
return function(windowW, windowH)
    local labelFont = M.font.get_font(30)
    local charW, charH = M.font.get_text_dimensions(labelFont, "0")
    local inputW = charW * 10.5
    local labelW = M.font.get_text_dimensions(labelFont, "ENTER USERNAME")
    local inputBox = M.inputBox:new(windowW / 2 - labelW / 2, windowH / 2, inputW, charH, 30, 8)
    return {
        widgets = {
            inputBox,
            M.label:new(windowW / 2, windowH / 2 - charH, "ENTER USERNAME", 30),
            M.button:new(windowW / 2 + labelW / 2 - charW * 3, windowH / 2, charW * 3, charH, "OK", 20,
                function()
                    local userName = inputBox:get_value()
                    if not userName then return end
                    M.readwrite.set_user_name(userName)
                    M.hud.push_menu("connection")
                end)
        }
    }
end
