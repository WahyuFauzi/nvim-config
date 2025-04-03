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
          "ts_ls",
          "html",
          "jdtls",
          "clangd",
          "eslint",
          "yamlls"
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
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("null-ls").setup()
    end
  }
}
