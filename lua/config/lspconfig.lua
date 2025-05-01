-- Lsp Setup
require("mason").setup()
require("mason-lspconfig").setup()

local lspconfig = require("lspconfig")
-- Lua LSP
lspconfig.lua_ls.setup {}

-- Deno LSP
lspconfig.denols.setup {
  root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
}

-- NodeJS LSP
lspconfig.ts_ls.setup {
  root_dir = lspconfig.util.root_pattern("package-lock.json"),
  single_file_support = false
}

-- Java LSP
lspconfig.jdtls.setup {}

-- HTML LSP
lspconfig.html.setup {}

-- Python LSP
lspconfig.pylsp.setup {}

-- Dart LSP
lspconfig.dartls.setup {}

-- Crystalline LSP
lspconfig.crystalline.setup {}
