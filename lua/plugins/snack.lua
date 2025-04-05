return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    bufdelete = { enabled = true },
    dim = { enabled = true },
    dashboard = {
      width = 60,
      row = nil,                                                                   -- dashboard position. nil for center
      col = nil,                                                                   -- dashboard position. nil for center
      pane_gap = 1,                                                                -- empty columns between vertical panes
      autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
      -- These settings are used by some built-in sections
      preset = {
        -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
        ---@type fun(cmd:string, opts:table)|nil
        pick = nil,
        -- Used by the `keys` section to show keymaps.
        -- Set your custom keymaps here.
        -- When using a function, the `items` argument are the default keymaps.
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
        header =
        [[ /$$     /$$ /$$   /$$ /$$     /$$ /$$   /$$ /$$$$$$ /$$$$$$$
|  $$   /$$/| $$  | $$|  $$   /$$/| $$  | $$|_  $$_/| $$__  $$
 \  $$ /$$/ | $$  | $$ \  $$ /$$/ | $$  | $$  | $$  | $$  \ $$
  \  $$$$/  | $$  | $$  \  $$$$/  | $$  | $$  | $$  | $$  | $$
   \  $$/   | $$  | $$   \  $$/   | $$  | $$  | $$  | $$  | $$
    | $$    | $$  | $$    | $$    | $$  | $$  | $$  | $$  | $$
    | $$    |  $$$$$$/    | $$    |  $$$$$$/ /$$$$$$| $$$$$$$/
    |__/     \______/     |__/     \______/ |______/|_______/ ]]
      },
      -- item field formatters
      formats = {
        icon = function(item)
          if item.file and item.icon == "file" or item.icon == "directory" then
            return M.icon(item.file, item.icon)
          end
          return { item.icon, width = 2, hl = "icon" }
        end,
        footer = { "%s", align = "center" },
        header = { "%s", align = "center" },
        file = function(item, ctx)
          local fname = vim.fn.fnamemodify(item.file, ":~")
          fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
          if #fname > ctx.width then
            local dir = vim.fn.fnamemodify(fname, ":h")
            local file = vim.fn.fnamemodify(fname, ":t")
            if dir and file then
              file = file:sub(-(ctx.width - #dir - 2))
              fname = dir .. "/…" .. file
            end
          end
          local dir, file = fname:match("^(.*)/(.+)$")
          return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
        end,
      },
      sections = {
        {
          section = "terminal",
          cmd = "viu ~/.config/nvim/giphy.gif",
          height = 28,
          padding = 0,
        },
        {
          pane = 2,
          { section = "header" },
          { section = "keys",   gap = 0, padding = 0 },
          { section = "startup" },
        },
      },
    },
    picker = {
      prompt = " ",
      sources = {},
      focus = "input",
      layout = {
        cycle = true,
        --- Use the default layout or vertical if the window is too narrow
        preset = function()
          return vim.o.columns >= 120 and "default" or "vertical"
        end,
      },
      ---@class snacks.picker.matcher.Config
      matcher = {
        fuzzy = true,          -- use fuzzy matching
        smartcase = true,      -- use smartcase
        ignorecase = true,     -- use ignorecase
        sort_empty = false,    -- sort results when the search string is empty
        filename_bonus = true, -- give bonus for matching file names (last part of the path)
        file_pos = true,       -- support patterns like `file:line:col` and `file:line`
        -- the bonusses below, possibly require string concatenation and path normalization,
        -- so this can have a performance impact for large lists and increase memory usage
        cwd_bonus = false,     -- give bonus for matching files in the cwd
        frecency = false,      -- frecency bonus
        history_bonus = false, -- give more weight to chronological order
      },
      sort = {
        -- default sort is by score, text length and index
        fields = { "score:desc", "#text", "idx" },
      },
      ui_select = true, -- replace `vim.ui.select` with the snacks picker
      ---@class snacks.picker.formatters.Config
      formatters = {
        text = {
          ft = nil, ---@type string? filetype for highlighting
        },
        file = {
          filename_first = false, -- display filename before the file path
          truncate = 40,          -- truncate the file path to (roughly) this length
          filename_only = false,  -- only show the filename
          icon_width = 2,         -- width of the icon (in characters)
          git_status_hl = true,   -- use the git status highlight group for the filename
        },
        selected = {
          show_always = false, -- only show the selected column when there are multiple selections
          unselected = true,   -- use the unselected icon for unselected items
        },
        severity = {
          icons = true,  -- show severity icons
          level = false, -- show severity level
          ---@type "left"|"right"
          pos = "left",  -- position of the diagnostics
        },
      },
      ---@class snacks.picker.previewers.Config
      previewers = {
        diff = {
          builtin = true,    -- use Neovim for previewing diffs (true) or use an external tool (false)
          cmd = { "delta" }, -- example to show a diff with delta
        },
        git = {
          builtin = true, -- use Neovim for previewing git output (true) or use git (false)
          args = {},      -- additional arguments passed to the git command. Useful to set pager options usin `-c ...`
        },
        file = {
          max_size = 1024 * 1024, -- 1MB
          max_line_length = 500,  -- max line length
          ft = nil, ---@type string? filetype for highlighting. Use `nil` for auto detect
        },
        man_pager = nil, ---@type string? MANPAGER env to use for `man` preview
      },
      ---@class snacks.picker.jump.Config
      jump = {
        jumplist = true,   -- save the current position in the jumplist
        tagstack = false,  -- save the current position in the tagstack
        reuse_win = false, -- reuse an existing window if the buffer is already open
        close = true,      -- close the picker when jumping/editing to a location (defaults to true)
        match = false,     -- jump to the first match position. (useful for `lines`)
      },
      toggles = {
        follow = "f",
        hidden = "h",
        ignored = "i",
        modified = "m",
        regex = { icon = "R", value = false },
      },
      win = {
        -- input window
        input = {
          keys = {
            -- to close the picker on ESC instead of going to normal mode,
            -- add the following keymap to your config
            -- ["<Esc>"] = { "close", mode = { "n", "i" } },
            ["/"] = "toggle_focus",
            ["<S-Tab>"] = { "list_up", mode = { "i", "n" } },
            ["<Tab>"] = { "list_down", mode = { "i", "n" } },
          },
          b = {
            minipairs_disable = true,
          },
        },
        -- result list window
        -- preview window
        preview = {
          keys = {
            ["<Esc>"] = "cancel",
            ["q"] = "close",
            ["i"] = "focus_input",
            ["<a-w>"] = "cycle_win",
          },
        },
      },
    },
    explorer = { enabled = true },
    indent = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    scope = { enabled = true },
    input = { enabled = true }
  },
  keys = {
    -- Top Pickers & Explorer
    { "<leader><space>", function() Snacks.picker.smart() end,            desc = "Smart Find Files" },
    { "<leader>,",       function() Snacks.picker.buffers() end,          desc = "Buffers" },
    { "<leader>/",       function() Snacks.picker.grep() end,             desc = "Grep" },
    { "<leader>:",       function() Snacks.picker.command_history() end,  desc = "Command History" },
    { "<leader>n",       function() Snacks.picker.notifications() end,    desc = "Notification History" },
    { "<C-n>",           function() Snacks.explorer() end,                desc = "File Explorer" },
    -- find
    { "<leader>fa",      function() Snacks.picker.files() end,            desc = "Find Files" },
    { "<leader>fg",      function() Snacks.picker.git_files() end,        desc = "Find Git Files" },
    -- git
    { "<leader>gb",      function() Snacks.picker.git_branches() end,     desc = "Git Branches" },
    { "<leader>gl",      function() Snacks.picker.git_log() end,          desc = "Git Log" },
    { "<leader>gL",      function() Snacks.picker.git_log_line() end,     desc = "Git Log Line" },
    { "<leader>gs",      function() Snacks.picker.git_status() end,       desc = "Git Status" },
    { "<leader>gS",      function() Snacks.picker.git_stash() end,        desc = "Git Stash" },
    { "<leader>gd",      function() Snacks.picker.git_diff() end,         desc = "Git Diff (Hunks)" },
    { "<leader>gf",      function() Snacks.picker.git_log_file() end,     desc = "Git Log File" },
    -- Grep
    { "<leader>sb",      function() Snacks.picker.lines() end,            desc = "Buffer Lines" },
    { "<leader>sB",      function() Snacks.picker.grep_buffers() end,     desc = "Grep Open Buffers" },
    { "<leader>sg",      function() Snacks.picker.grep() end,             desc = "Grep" },
    { "<leader>sw",      function() Snacks.picker.grep_word() end,        desc = "Visual selection or word", mode = { "n", "x" } },
    { "<leader>sj",      function() Snacks.picker.jumps() end,            desc = "Jumps" },
    -- Other
    { "<leader>z",       function() Snacks.zen() end,                     desc = "Toggle Zen Mode" },
    { "<leader>Z",       function() Snacks.zen.zoom() end,                desc = "Toggle Zoom" },
    { "<leader>.",       function() Snacks.scratch() end,                 desc = "Toggle Scratch Buffer" },
    { "<leader>S",       function() Snacks.scratch.select() end,          desc = "Select Scratch Buffer" },
    { "<leader>bd",      function() Snacks.bufdelete() end,               desc = "Delete Buffer" },
    { "<leader>cR",      function() Snacks.rename.rename_file() end,      desc = "Rename File" },
    { "<leader>gg",      function() Snacks.lazygit() end,                 desc = "Lazygit" },
    { "<c-/>",           function() Snacks.terminal() end,                desc = "Toggle Terminal" },
    { "]]",              function() Snacks.words.jump(vim.v.count1) end,  desc = "Next Reference",           mode = { "n", "t" } },
    { "[[",              function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference",           mode = { "n", "t" } },
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    }
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.indent():map("<leader>ug")

        -- initialization config
        Snacks.dim()
      end,
    })
  end,
}
