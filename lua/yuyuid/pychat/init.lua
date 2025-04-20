local chat = require('yuyuid.pychat.chat')

vim.api.nvim_create_user_command("StartAskLLM", function()
  chat.setup()
  chat.initialize()
  -- keymap
  -- chat.sendMessage()
  -- chat.closeConnection()
end, {})
