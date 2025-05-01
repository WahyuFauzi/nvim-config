local chat = require('yuyuid.pychat.chat')

vim.api.nvim_create_user_command("StartChatPy", function()
  chat.setup()
  chat.initialize()
end, {})

vim.api.nvim_create_user_command("StopChatPy", function()
  chat.close_connection()
  chat.close_chatpy()
end, {})

vim.api.nvim_create_user_command("RestartChatPy", function()
  chat.close_connection()
  chat.close_chatpy()
  -- small delay to ensure previous cleanup finishes
  vim.defer_fn(function()
    chat.setup()
    chat.initialize()
  end, 100) -- delay in milliseconds
end, {})
