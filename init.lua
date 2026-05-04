require("lazy-bootstrap")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true
vim.g.clipboard = "osc52"

require("lazy-plugins")
require("options")
require("keymaps")
require("autocmds")
