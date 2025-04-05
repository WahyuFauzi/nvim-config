return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    bufdelete = { enabled = true },
    dashboard = {
      width = 60,
      row = nil,                                                                   -- dashboard position. nil for center
      col = nil,                                                                   -- dashboard position. nil for center
      pane_gap = 4,                                                                -- empty columns between vertical panes
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
          cmd = "viu ~/.config/nvim/wonhee.webp",
          height = 17,
          padding = 1,
        },
        {
          pane = 2,
          { section = "keys",   gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
    },
    picker = {
      sources = {
        explorer = {
          -- your explorer picker configuration comes here
          -- or leave it empty to use the default settings
        }
      }
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
      end,
    })
  end,
}
