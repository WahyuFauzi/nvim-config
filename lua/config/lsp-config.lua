local lspconfig = require("lspconfig")
local capabilities = require('cmp_nvim_lsp').default_capabilities()
lspconfig.lua_ls.setup({})

lspconfig.tsserver.setup({
  capabilities = capabilities,
  filetypes = {
    "javascript",
    "typescript",
    "vue"
  },
})

-- Setup `gopls` server
lspconfig.gopls.setup {
    cmd = { "gopls" },
    filetypes = { "go", "gomod" },
    root_dir = lspconfig.util.root_pattern("go.mod", ".git"),
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
                unreachable = true,
            },
            staticcheck = true,
        },
    },
}

lspconfig.clangd.setup{}
-- lspconfig.sqlls.setup{}
-- lspconfig.sqls.setup{}
lspconfig.html.setup{}
