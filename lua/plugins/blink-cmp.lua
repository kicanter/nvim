--return {
--    {
--        "saghen/blink.cmp",
--        event = "VimEnter",
--        version = "1.*",
--        dependencies = {
--            -- Snippet Engine
--            {
--                "L3MON4D3/LuaSnip",
--                version = "2.*",
--                build = (function()
--                    return "make install_jsregexp"
--                end)(),
--                opts = {},
--            },
--            "folke/lazydev.nvim",
--        },
--        --- @module 'blink.cmp'
--        --- @type blink.cmp.Config
--        opts = {
--            keymap = {
--                preset = "default",
--            },
--
--            appearance = {
--                nerd_font_variant = "mono",
--            },
--
--            completion = {
--                documentation = { auto_show = false, auto_show_delay_ms = 500 },
--            },
--
--            sources = {
--                default = { "lsp", "path", "snippets", "lazydev" },
--                providers = {
--                    lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
--                },
--            },
--            snippets = { preset = "luasnip" },
--            fuzzy = { implementation = "lua" },
--            signature = { enabled = true },
--        },
--    },
--}
return {
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                { path = "~/Dev/candela.nvim"}
            },
        },
    },
    {
        "saghen/blink.cmp",
        event = "VimEnter",
        version = "1.*",
        dependencies = {
            -- Snippet Engine
            {
                "L3MON4D3/LuaSnip",
                version = "2.*",
                build = (function()
                    return "make install_jsregexp"
                end)(),
                opts = {},
            },
            { "folke/lazydev.nvim" },
            {
                "rafamadriz/friendly-snippets",
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                end,
            },
        },
        opts = {
            keymap = {
                preset = "default",
            },
            appearance = {
                nerd_font_variant = "mono",
            },
            completion = {
                documentation = { auto_show = false, auto_show_delay_ms = 500 },
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer", "lazydev" },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                },
            },
            snippets = { preset = "luasnip" },
            fuzzy = { implementation = "lua" },
            signature = { enabled = true },
        },
    },
}
