local Popup = require("nui.popup")
local Layout = require("nui.layout")
local Split = require("nui.split")
local event = require("nui.utils.autocmd").event

local UI = {}

function UI:open_window()
    self.popup = Popup({
        position = "50%",
        size = {
            width = 50,
            height = 20,
        },
        enter = true,
        focusable = true,
        border = {
            style = "rounded",
            text = {
                top = " My Plugin ",
                top_align = "center",
            },
        },
        buf_options = {
            modifiable = true,
            readonly = false,
        },
    })

    -- Mount the popup
    self.popup:mount()

    -- Close window when buffer loses focus
    self.popup:on(event.BufLeave, function()
        self.popup:unmount()
    end)

    -- Write some text
    vim.api.nvim_buf_set_lines(self.popup.bufnr, 0, -1, false, { "Hello, this is a floating window!" })
end

function UI:StartChat()

end

return UI
