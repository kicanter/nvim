vim.api.nvim_set_keymap("n", "<leader>ls", "", {
    desc = "Start live-preview server",
    callback = function()
        vim.api.nvim_exec2("LivePreview start", {})
        vim.fn.jobstart({
            "ssh",
            "local",
            string.format("xdg-open http://127.0.0.1:5500/RMIntegrationPoints.md"),
        }, { detach = true })
    end,
})
vim.api.nvim_set_keymap("n", "<leader>lc", "", {
    desc = "Close live-preview server",
    callback = function()
        vim.api.nvim_exec2("LivePreview close", {})
    end,
})

return {
    "brianhuster/live-preview.nvim",
    opts = {
        dynamic_root = true,
    },
}
