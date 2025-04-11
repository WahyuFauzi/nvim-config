-- Lsp Setup
require("mason").setup()
require("mason-lspconfig").setup()

-- Lua LSP
require("lspconfig").lua_ls.setup {}

-- Javascript/Typescript LSP
require("lspconfig").ts_ls.setup {}

-- Java LSP
require("lspconfig").jdtls.setup {}

-- Java LSP
require("lspconfig").html.setup {}
