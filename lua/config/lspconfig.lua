-- Lsp Setup
require("mason").setup()
require("mason-lspconfig").setup()
local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

-- Start setup Typescript LSP (ts_ls or denols)
local is_deno_project = function(root_dir)
  return util.path.exists(util.path.join(root_dir, "deno.json")) or
         util.path.exists(util.path.join(root_dir, "deno.jsonc"))
end

local setup_lsp = function()
  local cwd = vim.fn.getcwd()

  if is_deno_project(cwd) then
    lspconfig.denols.setup {
      root_dir = util.root_pattern("deno.json", "deno.jsonc"),
    }
  else
    lspconfig.ts_ls.setup {
      root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json"),
      single_file_support = false,
    }
  end
end

setup_lsp()

-- Lua LSP
lspconfig.lua_ls.setup {}

-- Java LSP
lspconfig.jdtls.setup {}

-- HTML LSP
lspconfig.html.setup {}

-- Python LSP
lspconfig.pylsp.setup {}
