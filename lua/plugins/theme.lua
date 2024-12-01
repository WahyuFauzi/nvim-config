-- return {
--     "tiagovla/tokyodark.nvim",
--     opts = {
--       transparent_background = false 
--     },
--     config = function(_, opts)
--         require("tokyodark").setup(opts) -- calling setup is optional
--         vim.cmd [[colorscheme tokyodark]]
--     end,
-- }
--
--
return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
}
