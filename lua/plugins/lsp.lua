return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    ensure_installed = {"lua_ls", "tsserver", "jdtls" }
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false
  }
};
