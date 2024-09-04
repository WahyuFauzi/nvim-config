return {
  {
    "williamboman/mason.nvim",
    lazy = false
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "tsserver",
          "html",
          "jdtls",
          "gopls",
          "clangd",
          "sqlls",
          "sqls"
        }
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false
  },
  {
    "mfussenegger/nvim-jdtls",
    lazy = false
  }
}
