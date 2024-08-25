require("default.remap")
require("default.prettify")
require("default.lazy")

--lsp
require("ftplugin.go")
local lspconfig = require("lspconfig")

-- lsp configuration
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = {
    "c",
    "lua",
    "vim",
    "vimdoc",
    "query",
    "markdown",
    "markdown_inline",
    "javascript",
    "typescript"
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,
}

-- lsp
lspconfig.tsserver.setup({
    on_attach = function(client, bufnr)
        -- Set up buffer-local keymaps (Neovim 0.7+)
        local buf_map = function(bufnr, mode, lhs, rhs, opts)
            opts = opts or { noremap = true, silent = true }
            vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
        end

        -- Use `gd` to go to definition
        buf_map(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
    end,
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    flags = {
        debounce_text_changes = 150,
    }
})

lspconfig.lua_ls.setup{}

-- indentation and block
require("ibl").setup({}) 

--comment
require('Comment').setup()

-- file explorer
require("nvim-tree").setup()

-- bufferline
vim.opt.termguicolors = true
require("bufferline").setup{}

-- Default configuration
require("tiny-inline-diagnostic").setup({
	signs = {
		left = "",
		right = "",
		diag = "●",
		arrow = "    ",
		up_arrow = "    ",
		vertical = " │",
		vertical_end = " └",
	},
	hi = {
		error = "DiagnosticError",
		warn = "DiagnosticWarn",
		info = "DiagnosticInfo",
		hint = "DiagnosticHint",
		arrow = "NonText",
		background = "CursorLine", -- Can be a highlight or a hexadecimal color (#RRGGBB)
		mixing_color = "None", -- Can be None or a hexadecimal color (#RRGGBB). Used to blend the background color with the diagnostic background color with another color.
	},
	blend = {
		factor = 0.27,
	},
	options = {
		-- Show the source of the diagnostic.
		show_source = false,

		-- Throttle the update of the diagnostic when moving cursor, in milliseconds.
		-- You can increase it if you have performance issues.
		-- Or set it to 0 to have better visuals.
		throttle = 20,

		-- The minimum length of the message, otherwise it will be on a new line.
		softwrap = 15,

		-- If multiple diagnostics are under the cursor, display all of them.
		multiple_diag_under_cursor = false,

		-- Enable diagnostic message on all lines.
		-- /!\ Still an experimental feature, can be slow on big files.
		multilines = false,

		overflow = {
			-- Manage the overflow of the message.
			--    - wrap: when the message is too long, it is then displayed on multiple lines.
			--    - none: the message will not be truncated.
			--    - oneline: message will be displayed entirely on one line.
			mode = "wrap",
		},

		-- Format the diagnostic message.
		-- Example:
		-- format = function(diagnostic)
		--     return diagnostic.message .. " [" .. diagnostic.source .. "]"
		-- end,
		format = nil,

		--- Enable it if you want to always have message with `after` characters length.
		break_line = {
			enabled = false,
			after = 30,
		},

		virt_texts = {
			priority = 2048,
		},
	},
})

-- transparent background
-- vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })
