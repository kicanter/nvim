vim.api.nvim_set_keymap("n", "<leader>qt", "", {
    desc = "Open todo-comments in quickfix list",
    callback = function()
        vim.api.nvim_exec2("TodoQuickFix", {})
    end,
})

return {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        keywords = {
            FIX = {
                alt = { "Fix", "fix", "BUG", "Bug", "bug" },
            },
            TODO = { alt = { "Todo", "todo" } },
            NOTE = { alt = { "Note", "note", "INFO", "Info", "info" } },
        },
        highlight = {
            pattern = [[.*<(KEYWORDS)\s*[^:]*:]],
            keyword = "bg",
        },
        search = {
            pattern = [[\b(KEYWORDS)(\(.*\))?:]],
            args = {
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
            },
        },
    },
}
