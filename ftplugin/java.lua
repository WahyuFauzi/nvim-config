local function get_workspace_dir()
    -- Get the project name from the current directory
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
    -- Base workspace directory path (customize this path as needed)
    local base_workspace_dir = '/home/yuyuid/projects/workspaces/'
    -- Combine base workspace directory with project name
    local workspace_dir = base_workspace_dir .. project_name
    return workspace_dir
end

-- Configuration for jdtls
local config = {
  cmd = {
        'java',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=WARNING',
        '-Xmx2g', -- Increase memory if needed
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '--enable-preview', -- Enable preview features in Java 21 if needed
        '-jar', '/home/yuyuid/packages/jdtls-1.38/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar',
        '-configuration', '/home/yuyuid/packages/jdtls-1.38/config_linux',
        '-data', get_workspace_dir(),
        '--enable-preview',
        '--add-modules', 'jdk.incubator.vector',
    },
    root_dir = vim.fs.root(0, {".git", "gradlew"}),
    -- on_attach = on_attach,
    -- capabilities = vim.lsp.protocol.make_client_capabilities()
}
-- Ensure the capabilities are correctly set up
local extendedClientCapabilities = require'jdtls'.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
config.init_options = {
    extendedClientCapabilities = extendedClientCapabilities
}

require('jdtls').start_or_attach(config)
