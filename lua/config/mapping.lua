-- copy and paste
-- Yank to clipboard
vim.api.nvim_set_keymap('n', 'y', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'y', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'Y', '"+Y', { noremap = true, silent = true })

-- Paste from clipboard
vim.api.nvim_set_keymap('n', 'p', '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'P', '"+P', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'p', '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'P', '"+P', { noremap = true, silent = true })

-- Set command to use Snack Input
vim.keymap.set("n", ":", function()
  Snacks.input.input({ prompt  = "Command" }, function(input) vim.cmd(input) end)
end)
