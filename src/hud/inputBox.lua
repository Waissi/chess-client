---@type Modules
local M = import "modules"

return setmetatable({
        ---@param self InputBoxModule
        ---@param x number
        ---@param y number
        ---@param w number
        ---@param h number
        ---@param fontSize number
        ---@param limit number
        new = function(self, x, y, w, h, fontSize, limit)
            return setmetatable(
                {
                    x = x,
                    y = y,
                    w = w,
                    h = h,
                    text = {},
                    state = "idle",
                    limit = limit,
                    font = M.font.get_font(fontSize),
                },
                {
                    __index = self
                }
            )
        end,

        ---@param inputBox InputBox
        ---@param char string
        on_text_input = function(inputBox, char)
            if not (inputBox.state == "listening") then return end
            if inputBox.limit and #inputBox.text == inputBox.limit then return end
            if inputBox.font:getWidth(table.concat(inputBox.text)) > inputBox.w - inputBox.font:getWidth("0") then return end
            inputBox.text[#inputBox.text + 1] = char
            return true
        end,

        ---@param inputBox InputBox
        ---@param x number
        ---@param y number
        on_mouse_pressed = function(inputBox, x, y)
            local hover = x > inputBox.x and
                x < inputBox.x + inputBox.w and
                y > inputBox.y and
                y < inputBox.y + inputBox.h
            inputBox.state = hover and "listening" or "idle"
        end,

        ---@param inputBox InputBox
        ---@param key string
        on_key_pressed = function(inputBox, key)
            if not (inputBox.state == "listening") then return end
            if key == "backspace" then
                inputBox.text[#inputBox.text] = nil
                return true
            elseif key == "v" and love.keyboard.isScancodeDown("lgui") then
                local clipboardText = love.system.getClipboardText()
                if clipboardText then
                    inputBox.text = { clipboardText }
                end
            end
        end,

        ---@param inputBox InputBox
        get_value = function(inputBox)
            if #inputBox.text < 1 then return end
            return table.concat(inputBox.text)
        end,

        ---@param inputBox InputBox
        draw = function(inputBox)
            love.graphics.setFont(inputBox.font)
            love.graphics.setColor(.5, .5, .5, .5)
            love.graphics.rectangle("fill", inputBox.x, inputBox.y, inputBox.w, inputBox.h)
            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.print(table.concat(inputBox.text), math.floor(inputBox.x), math.floor(inputBox.y))
            if inputBox.state == "listening" then
                love.graphics.rectangle("line", inputBox.x, inputBox.y, inputBox.w, inputBox.h)
            end
        end
    },
    {
        __index = import "widget"
    }
)
