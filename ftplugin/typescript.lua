local lspconfig = require("lspconfig")
-- lsp
-- lspconfig.tsserver.setup({
--     on_attach = function(client, bufnr)
--         -- Set up buffer-local keymaps (Neovim 0.7+)
--         local buf_map = function(bufnr, mode, lhs, rhs, opts)
--             opts = opts or { noremap = true, silent = true }
--             vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
--         end
-- 
--         -- Use `gd` to go to definition
--         buf_map(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
--     end,
--     capabilities = require('cmp_nvim_lsp').default_capabilities(),
--     flags = {
--         debounce_text_changes = 150,
--     }
-- })
--
lspconfig.tsserver.setup({
  on_attach = function(client, bufnr)
      -- Set up buffer-local keymaps (Neovim 0.7+)
      local buf_map = function(bufnr, mode, lhs, rhs, opts)
          opts = opts or { noremap = true, silent = true }
          vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
      end
  
      -- Use `gd` to go to definition
      buf_map(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  end,
--  capabilities = require('cmp_nvim_lsp').default_capabilities(),
--   flags = {
--       debounce_text_changes = 150,
--   }
  filetypes = {
    "javascript",
    "typescript",
  },
})
