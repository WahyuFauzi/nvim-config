require("config.lazy")
require("config.mapping")
require("config.lsp-config")

require("telescope").setup({
  defaults = {
    prompt_prefix = "   ",
    selection_caret = " ",
    entry_prefix = " ",
    sorting_strategy = "ascending",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
      },
      width = 0.87,
      height = 0.80,
    },
    file_ignore_patterns = {
      "node_modules/",
      "build/",
    },
    mappings = {
      n = { ["q"] = require("telescope.actions").close },
    },
  },
  extensions_list = { "themes", "terms" },
  extensions = {},
})

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = {
    "c",
    "lua",
    "typescript",
    "javascript",
    "vue",
    "svelte",
    "java",
    "kotlin",
    "go",
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
  highlight = {
    enable = true,
  },
}

require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  hijack_cursor = true,
  renderer = {
      full_name = true,
      group_empty = true,
      special_files = {},
      symlink_destination = false,
      indent_markers = {
        enable = true,
      },
      icons = {
        git_placement = "signcolumn",
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
        },
      },
    },
    update_focused_file = {
      enable = true,
      update_root = true,
      ignore_list = { "help" },
    },
    filters = {
      custom = {
        "^.git$",
      },
    },
    log = {
      enable = false,
      truncate = true,
      types = {
        all = false,
        config = false,
        copy_paste = false,
        diagnostics = false,
        git = false,
        profile = false,
        watcher = false,
      },
    }
})

-- Default options:
require('kanagawa').setup({
  compile = true,             -- enable compiling the colorscheme
  undercurl = true,            -- enable undercurls
  commentStyle = { italic = false },
  functionStyle = {},
  keywordStyle = { italic = false},
  statementStyle = { bold = false },
  typeStyle = {},
  transparent = true,         -- do not set background color
  dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
  terminalColors = false,       -- define vim.g.terminal_color_{0,17}
  overrides = function(colors)
      local theme = colors.theme
      return {
          TelescopeTitle = { fg = theme.ui.special, bold = true },
          TelescopePromptNormal = { bg = theme.ui.bg_p1 },
          TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
          TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
          TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
          TelescopePreviewNormal = { bg = theme.ui.bg_dim },
          TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
      }
  end,
  colors = {
    theme = {
      wave = {
          ui = {
              bg_gutter = "none"
          }
      },
      all = {
          ui = {
              bg_gutter = "none"
          }
      }
    }
  },
})

vim.cmd("colorscheme kanagawa-dragon")
