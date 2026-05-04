local candela_keymaps = {
    {
        lhs = "<leader>cds",
        rhs = "<Plug>CandelaUi",
        desc = "[Candela] toggle UI window",
    },
    {
        lhs = "<leader>cdr",
        rhs = "<Plug>CandelaRefresh",
        desc = "[Candela] refresh patterns in current buffer",
    },
    {
        lhs = "<leader>cdd",
        rhs = "<Plug>CandelaClear",
        desc = "[Candela] clear all patterns",
    },
    {
        lhs = "<leader>cdl",
        rhs = "<Plug>CandelaLightbox",
        desc = "[Candela] toggle lightbox window",
    },
    {
        lhs = "<leader>cdh",
        rhs = "<Plug>CandelaHelp",
        desc = "[Candela] open help menu",
    },
}

for _, keymap in ipairs(candela_keymaps) do
    vim.api.nvim_set_keymap("n", keymap.lhs, keymap.rhs, { desc = keymap.desc })
end

return {
    {
        ---@module "Candela"
        ---@type Candela.Config
        "KieranCanter/candela.nvim",
        opts = {
            icons = {
                nerd_font = true,
            }
        },
    },
}
