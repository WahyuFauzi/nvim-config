local lspconfig = require("lspconfig")

local function get_workspace_dir()
    -- Get the project name from the current directory
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
    -- Base workspace directory path (customize this path as needed)
    local base_workspace_dir = '/home/yuyuid/Projects/workspaces/'
    -- Combine base workspace directory with project name
    local workspace_dir = base_workspace_dir .. project_name
    return workspace_dir
end
local function has_deno_json()
    local deno_json_path = vim.fn.finddir("deno.json", ".;")
    return deno_json_path ~= ""
end

if has_deno_json() then
  lspconfig.denols.setup {
      root_dir = lspconfig.util.root_pattern("deno.json")
  }
else
  lspconfig.ts_ls.setup({
    root_dir = lspconfig.util.root_pattern("package-lock.json"),
    single_file_support = false
  })
end

lspconfig.clangd.setup({
  cmd = { "/home/linuxbrew/.linuxbrew/bin/clangd" },
})

lspconfig.jdtls.setup{
  cmd = {
        'java',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=WARNING',
        '-Xmx2g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--enable-preview',
        '-jar', '/var/home/yuyuid/.local/lsp/jdtls-1.45/plugins/org.eclipse.equinox.launcher_1.6.1000.v20250131-0606.jar',
        '-configuration', '/var/home/yuyuid/.local/lsp/jdtls-1.45/config_linux',
        '-data', get_workspace_dir(),
        -- '--enable-preview',
        -- '--add-modules', 'jdk.incubator.vector',
    },
    root_dir = vim.fs.root(0, {".git", "gradlew"}),
}


lspconfig.html.setup{}
lspconfig.rust_analyzer.setup{
  settings = {
    ['rust-analyzer'] = {
      diagnostics = {
        enable = false;
      }
    }
  }
}
lspconfig.pylsp.setup{
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = {'W391'},
          maxLineLength = 100
        }
      }
    }
  }
}
lspconfig.zls.setup{}
lspconfig.svelte.setup{
  cmd = { "node", "/var/home/yuyuid/Projects/personal/svelte-language-tools/packages/language-server/bin/server.js", "--stdio" }
}

-- lspconfig.custom_lsp = {
--     default_config = {
--         cmd = { "nc", "127.0.0.1", "2087" },
--         filetypes = { "javascript" },
--         root_dir = function() return vim.fn.getcwd() end,
--         settings = {},
--     },
-- }
--
-- -- Attach to buffer
-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = "javascript",
--     callback = function()
--         vim.lsp.start({ name = "custom_lsp", cmd = { "nc", "127.0.0.1", "2087" } })
--     end
-- })
