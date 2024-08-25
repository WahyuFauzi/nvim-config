return {
  "tiagovla/tokyodark.nvim",
  opts = {
    -- transparent_background = true,  -- Note the correction: 'bacground' -> 'background'
  },
  config = function(_, opts)
      require("tokyodark").setup(opts) -- calling setup is optional
      vim.cmd [[colorscheme tokyodark]]
  end,
}
