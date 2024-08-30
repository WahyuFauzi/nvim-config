vim.opt.tabstop = 2        -- Number of spaces that a <Tab> in the file counts for
vim.opt.shiftwidth = 2     -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true   -- Use spaces instead of tabs
vim.cmd("set number relativenumber")

local map = vim.keymap.set
local wk = require("which-key")
wk.add({
  -- telescope
  { "<leader>f", group = "file" }, -- group
  { "<leader>fw", "<cmd>Telescope live_grep<CR>", desc = "telescope live grep", mode = "n" },
  { "<leader>fa", "<cmd>Telescope find_files<cr>", desc = "find all files", mode = "n" }, --only tracked
  { "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "find in current buffer", mode = "n" },
  { "<leader>cm", "<cmd>Telescope git_commits<CR>", desc = "telescope git commits", mode = "n" },
  { "<leader>gt", "<cmd>Telescope git_status<CR>", desc = "telescope git status", mode = "n" },
  { "<leader>s",
    function()
	    require("flash").jump()
    end,
    desc = "flash",
    mode = "n"
  }
})

-- move in insert
map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })
map('n', '<C-n>', ':Ex<CR>', { desc = 'nvimtree toggle window' })

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

-- commenting
vim.keymap.set('n', '<leader>/', 'gcc', { desc = 'Toggle Comment', remap = true })
vim.keymap.set('v', '<leader>/', 'gc', { desc = 'Toggle comment', remap = true })

-- switch between buffer
vim.api.nvim_set_keymap('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Tab>', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })

--close buffer
vim.api.nvim_set_keymap('n', '<leader>x', ':bw<CR>', { silent = true })

--search
-- vim.keymap.set('n', '<leader>s', function() require("flash").jump() end, { desc = "flash" })
