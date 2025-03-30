return {
  "scalameta/nvim-metals",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  ft = { "scala", "sbt" },
  opts = function()
    local metals_config = require("metals").bare_config()
    metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()
    metals_config.init_options.statusBarProvider = "on"
    metals_config.settings = {
      metals = {
        enableSemanticHighlighting = true,
        showImplicitArguments = true,
        showInferredType = true,
      },
    }
    return metals_config
  end,
  config = function(plugin)
    local metals_config = require("metals").bare_config() -- Ensure we get a fresh config
    metals_config.on_attach = function(client, bufnr)
      -- Your on_attach function
    end

    local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = plugin.ft,
      callback = function()
        require("metals").initialize_or_attach(metals_config)
      end,
      group = nvim_metals_group,
    })
  end
}
