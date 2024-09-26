local font = love.graphics.newFont(30)

return setmetatable({
        ---@param self InputBoxModule
        ---@param x number
        ---@param y number
        ---@param w number
        ---@param h number
        ---@param callback function
        new = function(self, x, y, w, h, callback)
            return setmetatable(
                {
                    x = x,
                    y = y,
                    w = w,
                    h = h,
                    text = {},
                    callback = callback
                },
                {
                    __index = self
                }
            )
        end,

        ---@param inputBox InputBox
        ---@param char string
        on_text_input = function(inputBox, char)
            inputBox.text[#inputBox.text + 1] = char
            return true
        end,

        ---@param inputBox InputBox
        ---@param key string
        on_key_pressed = function(inputBox, key)
            if key == "return" then
                inputBox.callback(table.concat(inputBox.text))
                return true
            elseif key == "backspace" then
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
        draw = function(inputBox)
            love.graphics.setColor(.5, .5, .5, .5)
            love.graphics.rectangle("fill", inputBox.x, inputBox.y, inputBox.w, inputBox.h)
            love.graphics.setColor(1, 1, 1)
            love.graphics.setFont(font)
            love.graphics.print(table.concat(inputBox.text), inputBox.x, inputBox.y)
        end
    },
    {
        __index = import "widget"
    }
)
