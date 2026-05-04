require("lazy").setup({
    require("plugins/colors"),
    require("plugins/snacks"),
    require("plugins/gitsigns"),
    require("plugins/which-key"),
    require("plugins/lspconfig"),
    require("plugins/live-preview"),
    require("plugins/blink-cmp"),
    require("plugins/todo-comments"),
    require("plugins/mini"),
    require("plugins/treesitter"),
    require("plugins/indent_line"),
    require("plugins/lint"),
    require("plugins/autopairs"),
    require("plugins/candela"),
    require("plugins/kiron"), -- dev testing
}, {
    dev = { path = "~/Dev" },
    ui = {
        -- If you are using a Nerd Font: set icons to an empty table which will use the
        -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
        icons = vim.g.have_nerd_font and {} or {
            cmd = "⌘",
            config = "🛠",
            event = "📅",
            ft = "📂",
            init = "⚙",
            keys = "🗝",
            plugin = "🔌",
            runtime = "💻",
            require = "🌙",
            source = "📄",
            start = "🚀",
            task = "📌",
            lazy = "💤 ",
        },
    },
})
