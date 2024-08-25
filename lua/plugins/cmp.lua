return {
    "hrsh7th/nvim-cmp",
    lazy = true,
    config = function()
        local cmp = require('cmp')
        cmp.setup({
            snippet = {
                expand = function(args)
                    vim.fn["vsnip#anonymous"](args.body)  -- For `vsnip` users.
                    -- require('luasnip').lsp_expand(args.body)  -- For `luasnip` users.
                    -- require('snippy').expand_snippet(args.body)  -- For `snippy` users.
                    -- vim.fn["UltiSnips#Anon"](args.body)  -- For `ultisnips` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),  -- Accept currently selected item.
                ['<Tab>'] = cmp.mapping.select_next_item(),
                ['<S-Tab>'] = cmp.mapping.select_prev_item(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'vsnip' },  -- For vsnip users.
                -- { name = 'luasnip' },  -- For luasnip users.
                -- { name = 'ultisnips' },  -- For ultisnips users.
                -- { name = 'snippy' },  -- For snippy users.
            }, {
                { name = 'buffer' },
            })
        })

        -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' }
            }
        })

        -- Use cmdline & path source for ':'.
        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'path' }
            }, {
                { name = 'cmdline' }
            })
        })

        -- Setup lspconfig.
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        local lspconfig = require('lspconfig')
        lspconfig.lua_ls.setup {
            capabilities = capabilities,
        }
    end,
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/vim-vsnip",  -- For vsnip users.
        -- "L3MON4D3/LuaSnip",  -- For luasnip users.
        -- "saadparwaiz1/cmp_luasnip",  -- For luasnip users.
        -- "hrsh7th/cmp-nvim-lua",  -- Optional, for neovim lua development.
    }
}
