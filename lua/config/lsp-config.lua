local lspconfig = require("lspconfig")
local capabilities = require('cmp_nvim_lsp').default_capabilities()
lspconfig.lua_ls.setup({})

local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.eslint,  -- For linting
    -- null_ls.builtins.code_actions.eslint, -- For ESLint autofix
  },
})

lspconfig.ts_ls.setup({
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
lspconfig.html.setup{}

-- lspconfig.yamlls.setup()
